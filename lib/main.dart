/*
step1:update the photo

stp2 1. home page+
*/ 



// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:servicespot/pages/ForgetPassword_page.dart';
import 'package:servicespot/pages/Maps.dart';
import 'package:servicespot/pages/addService_page.dart';
import 'package:servicespot/pages/auth.dart';
import 'package:servicespot/pages/editeProfileWorker_page.dart';
import 'package:servicespot/pages/editeProfile_page.dart';
import 'package:servicespot/pages/editeWorkerProfile.dart';
import 'package:servicespot/pages/home_page.dart';
import 'package:servicespot/pages/login_page.dart';
import 'package:servicespot/pages/profile_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      routes: {
        '/auth': (context) => Auth(),
        '/loginPage': (context) => LoginPage(),
        '/signupPage': (context) => SignupPage(),
        '/homePage': (context) => HomePage(),
        '/editeProfilePage': (context) =>  EditeprofilePage(),
        '/addServicePage': (context) => AddservicePage(),
        '/settingsPage': (context) => SettingsPage(),
        '/editeProfileWorker': (context) => EditeprofileworkerPage(),
        '/forgetPasswordPage': (context) => ForgetpasswordPage(),
        '/profilePage': (context) => ProfilePage(),
        '/mapsscreen': (context) => MapScreen(),
        '/editeWorkerProfile': (context) => EditWorkerProfile(),
        
      },
    );
  }
}