import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AllWorkersMapPage extends StatefulWidget {
  const AllWorkersMapPage({Key? key}) : super(key: key);

  @override
  _AllWorkersMapPageState createState() => _AllWorkersMapPageState();
}

class _AllWorkersMapPageState extends State<AllWorkersMapPage> {
  LatLng? currentUserLocation;
  Set<Marker> markers = {};
  Map<String, dynamic>? selectedWorker;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchWorkers();
  }

  // Get the user's current location
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

    // Zoom the map to include the user's location
    if (_mapController != null && currentUserLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentUserLocation!, 12),
      );
    }
  }

  // Fetch all workers from Firestore
  Future<void> _fetchWorkers() async {
    List<String> categories = ["Plumber", "Cleaner", "Electrical", "Repair"];
    List<Map<String, dynamic>> workers = [];

    for (String category in categories) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(category).get();
      workers.addAll(snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['username'],
        'work': category,
        'phone': doc['phone'],
        'location': doc['location'],
        'email': doc['email'],
      }));
    }

    Set<Marker> loadedMarkers = workers.map((worker) {
      LatLng position = LatLng(
        double.parse(worker['location'].split(',')[0]),
        double.parse(worker['location'].split(',')[1]),
      );

      return Marker(
        markerId: MarkerId(worker['id']),
        position: position,
        onTap: () {
          setState(() {
            selectedWorker = worker;
          });
        },
        infoWindow: InfoWindow(
          title: worker['name'],
          snippet: worker['location'],
        ),
      );
    }).toSet();

    setState(() {
      markers = loadedMarkers;
    });
  }

  // Display the details of the selected worker at the top of the page
  Widget _buildWorkerDetails() {
    if (selectedWorker == null) return Container();
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("👷 ${selectedWorker!['name']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("🛠 ${selectedWorker!['work']}"),
          Text("📞 ${selectedWorker!['phone']}"),
          Text("✉️ ${selectedWorker!['email']}"),
          Text("📍 ${selectedWorker!['location']}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Workers Map"),
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
      ),
      body: Column(
        children: [
          // Display the worker details at the top
          _buildWorkerDetails(),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentUserLocation ?? LatLng(36.8065, 10.1815), // Default to Tunis
                zoom: 12.0,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }
}
