import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:servicespot/pages/addService_page.dart';
import 'package:servicespot/pages/editeProfileWorker_page.dart';
import 'package:servicespot/pages/editeProfile_page.dart';
import 'package:servicespot/pages/home_page.dart';
import 'package:servicespot/pages/home_page1.dart';
import 'package:servicespot/pages/login_page.dart';
import 'package:servicespot/pages/settings_page.dart';
import 'package:servicespot/pages/signup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print("Firebase initialization error: $e");
    print("Stack trace: $stackTrace");
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //update 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage1(),
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

