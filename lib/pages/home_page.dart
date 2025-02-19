import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Déclaration du contrôleur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  
                      _buildServiceTile('Repairs', Icons.build),
                      _buildServiceTile('Cleaning', Icons.cleaning_services),
                  
                  
                  
                  _buildServiceTile('Electrical', Icons.electrical_services),
                  _buildServiceTile('Plumbing', Icons.plumbing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour créer les tuiles de service
  Widget _buildServiceTile(String title, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        onTap: () {
          // Ajoute une action ici si nécessaire
          print('$title tapped');
        },
      ),
    );
  }
}
