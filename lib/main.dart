/*
step1:
el login te5em : ki tekteb el esem bel s7i7 tod5ol w kif tekteb bel 8alet ma tod5olech , w el logout fi el profil te5de
w kif to5rej el bara w tarja3 kanak 3amel login tod5ol direct ll home 

step2 :
wa9teli ya3mal sign up ttsajal el ma3loumat mta3a fi el fire base 


step3:
el button mta3 el Google te5dem bel s7i7
++

step4:
add the informations of the user to fire store

step5:
yekteb fi les informations mta3a fi el profile page

step6:
add service te5dem


stp7:
sign up location te5dem 

step8: 
upload photos done 

step9:
profile photo
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
        '/editeProfilePage': (context) => EditeprofilePage(),
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