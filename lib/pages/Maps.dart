import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

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

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _address1 = "${position.latitude},${position.longitude}";
      _isLoading = false;
    });

    await _getAddressFromLatLng(_selectedLocation!);

    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isFetchingAddress = true;
      _address = "Fetching location...";
      _address1 = "${position.latitude},${position.longitude}";
    });

    const String apiKey = "AIzaSyDgXjNXcDbH-lBqdT9FKfPGRYOFbY4ogbk";
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

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

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedLocation != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'address': _address,
      });
      print("User data updated successfully!");
    }
  }

  void _onNextPressed() async {
    if (_selectedLocation == null || _isFetchingAddress) return;

    await _getAddressFromLatLng(_selectedLocation!);
    await _updateUserData();

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
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: {}, // << No red marker
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}