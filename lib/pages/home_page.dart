import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Updated service categories as per your request
  Map<String, List<Map<String, dynamic>>> servicesData = {
    'Repair': [],
    'Cleaner': [],
    'Electrical': [],
    'Plumber': [],
  };

  @override
  void initState() {
    super.initState();
    _fetchServicesData();
  }

  // Fetch data from Firebase Firestore
  Future<void> _fetchServicesData() async {
    try {
      for (var category in servicesData.keys) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(category) // Corrected collection names
            .get();

        // Debugging: Print fetched data
        print("Fetched data for $category: ${snapshot.docs}");

        List<Map<String, dynamic>> servicesList = snapshot.docs.map((doc) {
          return {
            'name': doc['username'] ?? "No Name",
            'work': category,
            'phone': doc['phone'] ?? "No Phone",
            'location': doc['location'] ?? "No Location",
            'email': doc['email'] ?? "No Email",
          };
        }).toList();

        setState(() {
          servicesData[category] = servicesList;
        });

        if (servicesList.isEmpty) {
          print("No data found for $category.");
        }
      }
    } catch (e) {
      print("Error fetching services data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              _ServiceTitle("The Services", ""),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: _buildServiceTile('Repair', Icons.build)),
                  Expanded(child: _buildServiceTile('Cleaner', Icons.cleaning_services)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildServiceTile('Electrical', Icons.electrical_services)),
                  Expanded(child: _buildServiceTile('Plumber', Icons.plumbing)),
                ],
              ),

              const SizedBox(height: 20),

              // Build Service Categories
              _buildServiceCategory("Repair", servicesData['Repair']),
              _buildServiceCategory("Cleaner", servicesData['Cleaner']),
              _buildServiceCategory("Electrical", servicesData['Electrical']),
              _buildServiceCategory("Plumber", servicesData['Plumber']),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build service categories
  Widget _buildServiceCategory(String category, List<Map<String, dynamic>>? services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ServiceTitle("The $category", "See All"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: services!.isNotEmpty
                ? services.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _ServiceBox(service),
                    );
                  }).toList()
                : [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _ServiceBox({'name': "No services", 'work': category}),
                    )
                  ],
          ),
        ),
      ],
    );
  }

  // Service Box to display individual service details
  Widget _ServiceBox(Map<String, dynamic> service) {
    return Container(
      width: 270,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service['name'], style: const TextStyle(fontSize: 15)),
              Text(service['work'], style: const TextStyle(fontSize: 15)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Call",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Service Title Widget
  Widget _ServiceTitle(String title, String seeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            print("$title See All tapped");
          },
          child: Text(
            seeAll,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(2, 173, 103, 1.0),
            ),
          ),
        ),
      ],
    );
  }

  // Service Tile Widget
  Widget _buildServiceTile(String title, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          print('$title tapped');
        },
      ),
    );
  }
}
