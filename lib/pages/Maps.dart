import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedLocation;
  String _address = "Fetching location...";
  String _address1 = "Fetching location...";
  bool _isLoading = true;
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _address1 = "${position.latitude},${position.longitude}";
      _isLoading = false;
    });

    // Get address from LatLng
    await _getAddressFromLatLng(_selectedLocation!);

    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
  }

  // Method to fetch address using Google Geocoding API
  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isFetchingAddress = true;
      _address = "Fetching location...";
      _address1 = "${position.latitude},${position.longitude}";
    });

    const String apiKey = "YOUR_GOOGLE_API_KEY"; // Replace with your actual API key
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      print("Geocoding Response: $data"); // Debugging: Print API response

      if (response.statusCode == 200 && data["status"] == "OK") {
        setState(() {
          _address = data["results"][0]["formatted_address"];
        });
      } else {
        setState(() {
          _address = "Address not found (API error: ${data["status"]})";
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error retrieving address: $e";
      });
    } finally {
      setState(() {
        _isFetchingAddress = false;
      });
    }
  }

  // Next button callback
  void _onNextPressed() async {
    if (_selectedLocation == null || _isFetchingAddress) return;

    // Ensure we have the latest address before proceeding
    await _getAddressFromLatLng(_selectedLocation!);
    
    Navigator.pop(context, _address1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[600],
        actions: [
          TextButton(
            onPressed: _isFetchingAddress ? null : _onNextPressed,
            child: Text(
              _isFetchingAddress ? "Loading..." : "NEXT",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation ?? LatLng(0.0, 0.0),
                      zoom: 14,
                    ),
                    markers: _selectedLocation == null
                        ? {}
                        : {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _selectedLocation!,
                              draggable: true,
                              onDragEnd: (newPosition) async {
                                setState(() {
                                  _selectedLocation = newPosition;
                                });
                                await _getAddressFromLatLng(newPosition);
                              },
                            ),
                          },
                    onTap: (LatLng location) async {
                      setState(() {
                        _selectedLocation = location;
                      });
                      await _getAddressFromLatLng(location);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,


                  
                  child: Text(
                    _address1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
