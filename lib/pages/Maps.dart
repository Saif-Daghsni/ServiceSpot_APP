import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedLocation;
  bool _isLoading = true;

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
      _isLoading = false;
    });

    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google maps',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        actions: [
          TextButton(
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, "${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}");
              }
            },
            child: const Text("NEXT", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: _selectedLocation!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedLocation!,
                  draggable: true,
                  onDragEnd: (newPosition) {
                    setState(() {
                      _selectedLocation = newPosition;
                    });
                  },
                ),
              },
              onTap: (LatLng location) {
                setState(() {
                  _selectedLocation = location;
                });
              },
            ),
    );
  }
}
