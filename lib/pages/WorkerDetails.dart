import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WorkerDetailsPage extends StatefulWidget {
  final Map<String, dynamic> service;

  const WorkerDetailsPage({Key? key, required this.service}) : super(key: key);

  @override
  State<WorkerDetailsPage> createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  LatLng? currentUserLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permissions are denied.");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentUserLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Worker Image"),
        content: Image.network(imageUrl, fit: BoxFit.cover),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng workerLocation = LatLng(
      double.parse(widget.service['location'].split(',')[0]),
      double.parse(widget.service['location'].split(',')[1]),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service['name'] ?? "Unknown Worker"),
        backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              if (widget.service['image'] != null &&
                  widget.service['image'].toString().isNotEmpty) {
                _showImageDialog(context, widget.service['image']);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("No image available."),
                ));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Worker Info
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${widget.service['name']}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Phone: ${widget.service['phone'] ?? 'No Phone'}"),
                Text("Email: ${widget.service['email'] ?? 'No Email'}"),
                Text("Work: ${widget.service['work']}"),
                Text("Location: ${widget.service['location']}"),
              ],
            ),
          ),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: workerLocation,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                Marker(
                  markerId: MarkerId(widget.service['id']),
                  position: workerLocation,
                  infoWindow: InfoWindow(
                    title: widget.service['name'],
                    snippet: widget.service['location'],
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
