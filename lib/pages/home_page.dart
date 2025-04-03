import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicespot/pages/WorkerDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> _fetchServicesData() async {
    try {
      for (var category in servicesData.keys) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(category)
            .get();

        print("Fetched ${snapshot.docs.length} documents for $category.");

        List<Map<String, dynamic>> servicesList = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['username'] ?? "No Name",
            'work': category,
            'phone': doc['phone'] ?? "No Phone",
            'location': doc['location'] ?? "No Location",
            'email': doc['email'] ?? "No Email",
            'isFavorite': doc['isFavorite'] ?? false,
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

  Future<void> _toggleFavorite(Map<String, dynamic> service) async {
    String serviceId = service['id'];
    String category = service['work'];
    bool newFavoriteStatus = !(service['isFavorite'] ?? false);

    try {
      await FirebaseFirestore.instance
          .collection(category)
          .doc(serviceId)
          .update({'isFavorite': newFavoriteStatus});

      setState(() {
        for (var i = 0; i < servicesData[category]!.length; i++) {
          if (servicesData[category]![i]['id'] == serviceId) {
            servicesData[category]![i]['isFavorite'] = newFavoriteStatus;
            break;
          }
        }
      });
    } catch (e) {
      print("Error updating isFavorite: $e");
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

  Widget _buildServiceCategory(String category, List<Map<String, dynamic>>? services) {
    print("Building category: $category with services: ${services?.length}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ServiceTitle("The $category", "See All"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: services != null && services.isNotEmpty
                ? services.map((service) {
                    print("Adding service to UI: $service");
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
Widget _ServiceBox(Map<String, dynamic> service) {
  bool isFavorite = service['isFavorite'] ?? false;
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkerDetailsPage(service: service),
        ),
      );
    },
    child: Container(
      width: 200,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service['name'] ?? "Unknown",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                service['work'] ?? "Unknown",
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("📍 ${service['location'] ?? 'No Location'}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text("📞 ${service['phone'] ?? 'No Phone'}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text("✉️ ${service['email'] ?? 'No Email'}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {}, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Call", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              IconButton(
                onPressed: () => _toggleFavorite(service),
                icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

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
