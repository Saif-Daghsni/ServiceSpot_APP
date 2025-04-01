// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servicespot/pages/Maps.dart';

class EditeprofilePage extends StatefulWidget {
  const EditeprofilePage({super.key});

  @override
  State<EditeprofilePage> createState() => _EditeprofilePageState();
}

class _EditeprofilePageState extends State<EditeprofilePage> {
  File? selectedImage;
  String? imageBase64;
  Uint8List? imageBytes;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController location = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) { 
      File imageFile = File(file.path);
      List<int> imageBytesList = await imageFile.readAsBytes();
      setState(() {
        selectedImage = imageFile;
        imageBase64 = base64Encode(imageBytesList);
      });
    }
  }

  Future<void> _navigateToMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        location.text = selectedLocation;
      });
    }
  }

  // Fetch the current user's data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      // Set the data in the text controllers
      userNameController.text = userData['username'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneNumberController.text = userData['phone'] ?? '';
      location.text = userData['location'] ?? '';
      passwordController.text = userData['password'] ?? '';

      String? storedImageBase64 = userData['imageBase64'];

      if (storedImageBase64 != null && storedImageBase64.isNotEmpty) {
        try {
          Uint8List decodedImage = base64Decode(storedImageBase64);
          setState(() {
            imageBytes = decodedImage;
          });
        } catch (e) {
          print("Error decoding image: $e");
        }
      }
    }
  }

  // Update the user data in Firestore
  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'username': userNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'location': location.text,
        'imageBase64': imageBase64 ?? '',
      });
      print("User data updated successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Edit Profile",
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
        padding: EdgeInsets.only(left: 40, right: 20, top: 30, bottom: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your profile photo",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 10),

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

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.transparent, width: 2),
                    ),
                  ),
                  child: Text(
                    "Change the photo",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 10),
              _buildTextLabel("User Name"),
              _buildTextField(userNameController, Icons.person, "User Name"),

              SizedBox(height: 10),
              _buildTextLabel("Email"),
              _buildTextField(emailController, Icons.mail, "Email"),

              SizedBox(height: 10),
              _buildTextLabel("Phone Number"),
              _buildTextField(phoneNumberController, Icons.phone, "Phone Number"),

              SizedBox(height: 10),
              _buildTextLabel("Location"),

              SizedBox(height: 10),
              GestureDetector(
                onTap: _navigateToMap,
                child: AbsorbPointer(
                  child: _buildTextField(location, Icons.location_on, "Tap to choose location"),
                ),
              ),

              SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _updateUserData();
                    Navigator.pushNamed(context, '/auth');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
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
}

Widget _buildTextLabel(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _buildTextField(TextEditingController controller, IconData icon, String hintText) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    ),
  );
}
