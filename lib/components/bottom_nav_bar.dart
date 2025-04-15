import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(234, 234, 234, 1.0), 
      child: SafeArea( 
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(2, 173, 103, 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8), 
          child: GNav(
            color: Colors.grey[400],
            activeColor: Colors.grey.shade700,
            tabActiveBorder: Border.all(color: Colors.white),
            tabBackgroundColor: Colors.grey.shade100,
            mainAxisAlignment: MainAxisAlignment.center,
            onTabChange: (value) => onTabChange!(value),
            gap: 5, //the spacing between the icon and the text
            tabMargin: const EdgeInsets.symmetric(horizontal: 14), 
            tabs: const [
              GButton(
                padding: EdgeInsets.all(12), 
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                padding: EdgeInsets.all(12), 
                icon: Icons.favorite,
                text: 'Favorite',
              ),
              GButton(
                padding: EdgeInsets.all(12), 
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                padding: EdgeInsets.all(12), 
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