import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:servicespot/components/bottom_nav_bar.dart';
import 'package:servicespot/pages/addService_page.dart';
import 'package:servicespot/pages/auth.dart';
import 'package:servicespot/pages/editeProfileWorker_page.dart';
import 'package:servicespot/pages/editeProfile_page.dart';
import 'package:servicespot/pages/favorite_page.dart';
import 'package:servicespot/pages/home_page.dart';
import 'package:servicespot/pages/login_page.dart';
import 'package:servicespot/pages/profile_page.dart';
import 'package:servicespot/pages/search_page.dart';
import 'package:servicespot/pages/settings_page.dart';
import 'package:servicespot/pages/signup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      routes: {
        '/loginPage': (context) => LoginPage(),
        '/signupPage': (context) => SignupPage(),
        '/homePage': (context) => HomePage(),
        '/editeProfilePage': (context) => EditeprofilePage(),
        '/addServicePage': (context) => AddservicePage(),
        '/settingsPage': (context) => SettingsPage(),
        '/editeProfileWorker': (context) => EditeprofileworkerPage(),
      },
    );
  }
}

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
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
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ServiceSpot",
            style: TextStyle(
              color: Color.fromRGBO(235, 239, 238, 1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color.fromRGBO(235, 239, 238, 1.0),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/loginPage');
            },
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: pages[_selectedIndex],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: navigateBottomBar,
      ),
    );
  }
}
