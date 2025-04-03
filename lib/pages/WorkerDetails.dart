import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkerDetailsPage extends StatelessWidget {
  final Map<String, dynamic> service;

  const WorkerDetailsPage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng workerLocation = LatLng(
      double.parse(service['location'].split(',')[0]), // Assuming location is 'lat,lng'
      double.parse(service['location'].split(',')[1]),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(service['name'] ?? "Unknown Worker"),
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
      ),
      body: Column(
        children: [
          // Top half: Worker Information
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${service['name']}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Phone: ${service['phone'] ?? 'No Phone'}"),
                Text("Email: ${service['email'] ?? 'No Email'}"),
                SizedBox(height: 10),
                Text("Work: ${service['work']}"),
                Text("Location: ${service['location']}"),
              ],
            ),
          ),
          
          // Bottom half: Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: workerLocation,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(service['id']),
                  position: workerLocation,
                  infoWindow: InfoWindow(
                    title: service['name'],
                    snippet: service['location'],
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
