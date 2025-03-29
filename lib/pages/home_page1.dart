import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicespot/components/bottom_nav_bar.dart';
import 'package:servicespot/pages/favorite_page.dart';
import 'package:servicespot/pages/home_page.dart';
import 'package:servicespot/pages/profile_page.dart';
import 'package:servicespot/pages/search_page.dart';
class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  
  final user = FirebaseAuth.instance.currentUser!;
  
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    const HomePage(),
    const FavoritePage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ServiceSpot",
            style: TextStyle(
              color: Color.fromRGBO(2, 173, 103, 1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromRGBO(2, 173, 103, 1.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/maps');
            },
          ),
        ],
      ),//backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: pages[_selectedIndex],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: navigateBottomBar,
      ),
    );
  }
}
