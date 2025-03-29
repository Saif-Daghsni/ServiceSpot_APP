import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: Column(
        children: [
          // Champ de recherche en haut
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
             TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(2, 173, 103, 1.0),
                hintText: 'What service are you looking for?',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            ],),
          ),

          // Espace pour centrer le contenu
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Évite de prendre trop d'espace
                children: [
                  Image.asset(
                    "assets/no-results.png",
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Try to do a search",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
