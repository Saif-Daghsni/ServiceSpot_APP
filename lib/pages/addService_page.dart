// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddservicePage extends StatefulWidget {
  const AddservicePage({super.key});

  @override
  State<AddservicePage> createState() => _AddservicePageState();
}

class _AddservicePageState extends State<AddservicePage> {

  String imageUrl='';

  TextEditingController serviceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Function to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData =
            await FirebaseFirestore.instance
                .collection('users') // Make sure this is the correct collection
                .doc(user.uid)
                .get();

        if (userData.exists) {
          setState(() {
            userName.text = userData['username'] ?? 'No Username';
            phoneNumber.text = userData['phone'] ?? 'No Phone Number';
            email.text = userData['email'] ?? 'No Email'; // Fixed typo
            location.text = userData['location'] ?? 'No Location';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  /// Function to save data in Firestore
  Future<void> _saveData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('workers')
            .doc(user.uid)
            .set({
              'username': userName.text,
              'phone': phoneNumber.text,
              'email': email.text,
              'service': serviceController.text,
              'price': priceController.text,
              'location': location.text,
              'userId': user.uid,
            });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Service saved successfully!")),
        );

        // Navigate to favorite page
        Navigator.pushNamed(context, '/auth');
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to save service: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 239, 238, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Add Service",
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLabel("The service"),
              _buildTextField(
                serviceController,
                Icons.handyman,
                "Write your service",
              ),
              _buildLabel("The price per hour"),
              _buildTextField(
                priceController,
                Icons.attach_money,
                "The price per hour",
              ),
              const SizedBox(height: 50),

              // add photos
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:()async {
                    ImagePicker imagePicker=ImagePicker();
                    XFile ? file = await imagePicker.pickImage(source:ImageSource.gallery);

                    if(file==null)return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages = referenceRoot.child('images');

                    Reference referenceImagetoUpload = referenceDirImages.child("workers photos");

                    try {

                    await referenceImagetoUpload.putFile(File(file!.path));

                    imageUrl = await referenceImagetoUpload.getDownloadURL();
                      
                    } catch (e) {
                      
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Correct way to set border radius
                      side: const BorderSide(
                        // Add border here instead of `decoration`
                        color: Color.fromRGBO(2, 173, 103, 1.0),
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Add Photos",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(2, 173, 103, 1.0),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveData, // Call the save function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Text(
          text,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromRGBO(2, 173, 103, 1.0),
            width: 2,
          ),
        ),
      ),
    );
  }
}
