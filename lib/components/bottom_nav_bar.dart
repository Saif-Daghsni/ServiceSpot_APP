import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(234, 234, 234, 1.0), // Background color for SafeArea
      child: SafeArea( // Wrap in SafeArea to avoid system UI overlap
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Add margin
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(2, 173, 103, 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8), // Adjust vertical padding
          child: GNav(
            color: Colors.grey[400],
            activeColor: Colors.grey.shade700,
            tabActiveBorder: Border.all(color: Colors.white),
            tabBackgroundColor: Colors.grey.shade100,
            mainAxisAlignment: MainAxisAlignment.center,
            onTabChange: (value) => onTabChange!(value),
            gap: 5, // Space between icon and text
            tabMargin: const EdgeInsets.symmetric(horizontal: 14), // Reduce horizontal margin
            tabs: const [
              GButton(
                padding: EdgeInsets.all(12), // Adjust padding
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                padding: EdgeInsets.all(12), // Adjust padding
                icon: Icons.favorite,
                text: 'Favorite',
              ),
              GButton(
                padding: EdgeInsets.all(12), // Adjust padding
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                padding: EdgeInsets.all(12), // Adjust padding
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}