import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  Uint8List? imageBytes;
  
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();


   @override
  void initState() {
    super.initState();
    _fetchUserData(); // Call to fetch user data when the page is loaded
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Set the data in the text controllers
      userNameController.text = userData['username'] ?? 'No Username';
      phoneNumberController.text = userData['phone'] ?? 'No Phone Number';

      String? imageBase64 = userData['imageBase64'];

      if (imageBase64 != null && imageBase64.isNotEmpty) {
        try {
          Uint8List decodedImage = base64Decode(imageBase64);
          setState(() {
            imageBytes = decodedImage;
          });
        } catch (e) {
          print("Error decoding image: $e");
        }
      }
      
    }
  }

 

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 40, right: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(2, 173, 103, 1.0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Row(
                children: [
                  imageBytes != null
            ? ClipOval(
                child: Image.memory(
                  imageBytes!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(
            Icons.person,
            color: Colors.white,
            size: 90,
          ),


                  SizedBox(width: 30),
                  SizedBox(
                    width: 140,
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userNameController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          phoneNumberController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 50, top: 40, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editeProfilePage');
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(125, 125, 125, 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 15),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/addServicePage');
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(125, 125, 125, 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.handyman, color: Colors.white),
                              SizedBox(width: 15),
                              Text(
                                "Add service",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/editeWorkerProfile');
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(125, 125, 125, 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings, color: Colors.white),
                              SizedBox(width: 15),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(211, 47, 47, 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 15),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
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
