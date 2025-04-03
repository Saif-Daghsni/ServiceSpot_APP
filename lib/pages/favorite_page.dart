import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteServices = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteServices();
  }

  Future<void> _fetchFavoriteServices() async {
    try {
      List<Map<String, dynamic>> fetchedFavorites = [];
      List<String> categories = ["Plumber", "Cleaner", "Electrical", "Repair"];

      for (var category in categories) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(category)
            .where('isFavorite', isEqualTo: true)
            .get();

        for (var doc in snapshot.docs) {
          fetchedFavorites.add({
            'id': doc.id,
            'name': doc['username'] ?? "No Name",
            'work': category,
            'phone': doc['phone'] ?? "No Phone",
            'location': doc['location'] ?? "No Location",
            'email': doc['email'] ?? "No Email",
            'isFavorite': doc['isFavorite'] ?? false,
          });
        }
      }

      setState(() {
        favoriteServices = fetchedFavorites;
      });
    } catch (e) {
      print("Error fetching favorite services: $e");
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
        favoriteServices.removeWhere((item) => item['id'] == serviceId);
      });
    } catch (e) {
      print("Error updating isFavorite: $e");
    }
  }

  Widget _ServiceBox(Map<String, dynamic> service) {
    bool isFavorite = service['isFavorite'] ?? false;
    return Container(
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
              Text(service['name'], style: const TextStyle(fontSize: 15)),
              Text(service['work'], style: const TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 10),
          Text("📍 ${service['location']}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text("📞 ${service['phone']}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text("✉️ ${service['email']}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
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
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
      body: favoriteServices.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/No Search.png", height: 120, width: 120),
                  const SizedBox(height: 10),
                  const Text("You didn't like any work", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              itemCount: favoriteServices.length,
              itemBuilder: (context, index) {
                return _ServiceBox(favoriteServices[index]);
              },
            ),
    );
  }
}