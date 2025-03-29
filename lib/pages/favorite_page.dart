import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: Column(
        
        children: [
          // Espace pour centrer le contenu
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Évite de prendre trop d'espace
                children: [
                  Image.asset(
                    "assets/No Search.png",
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You didn't like any work",
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
