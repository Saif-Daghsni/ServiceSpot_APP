import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";
  String selectedCategory = "All";
  List<Map<String, dynamic>> searchResults = [];
  List<String> categories = ["All", "Plumber", "Cleaner", "Electrical", "Repair"];

  void _performSearch() async {
    setState(() {
      searchResults.clear();
    });

    QuerySnapshot snapshot;
    if (selectedCategory == "All") {
      // Search across all categories
      List<Map<String, dynamic>> tempResults = [];
      for (String category in categories.sublist(1)) {
        snapshot = await FirebaseFirestore.instance
            .collection(category)
            .where('username', isGreaterThanOrEqualTo: searchQuery)
            .where('username', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .get();

        tempResults.addAll(snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['username'],
              'work': category,
              'phone': doc['phone'],
              'location': doc['location'],
              'email': doc['email'],
              'isFavorite': doc['isFavorite'] ?? false,
            }));
      }
      setState(() {
        searchResults = tempResults;
      });
    } else {
      // Search in the selected category
      snapshot = await FirebaseFirestore.instance
          .collection(selectedCategory)
          .where('username', isGreaterThanOrEqualTo: searchQuery)
          .where('username', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc['username'],
              'work': selectedCategory,
              'phone': doc['phone'],
              'location': doc['location'],
              'email': doc['email'],
              'isFavorite': doc['isFavorite'] ?? false,
            }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
      body: Column(
        children: [
          // Search bar & filter dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => searchQuery = value,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(2, 173, 103, 1.0),
                      hintText: 'What service are you looking for?',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      searchResults.clear(); // Clear previous results
                    });
                  },
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: Text("Search",style: TextStyle( color: Colors.blue)),
                ),
              ],
            ),
          ),

          // Search results
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/no-results.png", height: 120, width: 120),
                        SizedBox(height: 10),
                        Text("Try to do a search", style: TextStyle(fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return _ServiceBox(searchResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
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

  Future<void> _toggleFavorite(Map<String, dynamic> service) async {
    String serviceId = service['id'];
    String category = service['work'];
    bool newFavoriteStatus = !(service['isFavorite'] ?? false);
    await FirebaseFirestore.instance.collection(category).doc(serviceId).update({'isFavorite': newFavoriteStatus});
    setState(() {
      service['isFavorite'] = newFavoriteStatus;
    });
  }
}
