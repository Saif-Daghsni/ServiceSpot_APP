import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servicespot/pages/Maps.dart';
import 'package:servicespot/pages/auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? selectedImage;
  String? imageBase64;

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passWord = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController location = TextEditingController();

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

  Future signup() async {
    try {
      if (passWord.text.trim() != confirmPassword.text.trim()) {
        print("**** Passwords do not match ****");
        return;
      }

      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: passWord.text.trim(),
          );

      // Ensure Firestore is initialized before using it
      await FirebaseFirestore.instance
    .collection('users')
    .doc(userCredential.user!.uid)
    .set({
      'username': userName.text.trim(),
      'email': email.text.trim(),
      'phone': phoneNumber.text.trim(),
      'location': location.text.trim(),
      'imageBase64': imageBase64 ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      print("✅ Firestore save succeeded");
    }).catchError((error) {
      print("********************* Firestore save failed: $error");
    });


      print("User registered and data saved to Firestore!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Auth()),
      );
    } catch (e) {
      print("Signup error: $e"); // Print the actual error
    }
  }

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    passWord.dispose();
    confirmPassword.dispose();
    phoneNumber.dispose();
    location.dispose();
    super.dispose();
  }

Future<void> _pickImage() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

  if (file != null) {
    File imageFile = File(file.path);

    // Compress the image
    List<int>? compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 300,
      minHeight: 300,
      quality: 50, // 0 - 100
    );

    if (compressedBytes != null) {
      setState(() {
        selectedImage = imageFile;
        imageBase64 = base64Encode(compressedBytes);
      });
    } else {
      print("Image compression failed.");
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
      body: Column(
        children: [
          // 1st box
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              color: Color.fromRGBO(2, 173, 103, 1.0),
              padding: EdgeInsets.only(left: 25, right: 50, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),

          // 2nd box
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 50, top: 40, right: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(235, 239, 238, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(2, 173, 103, 1.0),
                      ),
                    ),
                    SizedBox(height: 20),

                    _buildLabel("User photo"),

                    SizedBox(height: 10),

                    selectedImage != null
                        ? Image.file(
                          selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : const Text('No image selected'),
                    SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: const Color.fromRGBO(2, 173, 103, 1.0),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "Add Photo",
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromRGBO(2, 173, 103, 1.0),
                          ),
                        ),
                      ),
                    ),

                    _buildLabel("User name"), SizedBox(height: 5),
                    // User Name Input Field
                    _buildTextField(
                      controller: userName,
                      icon: Icons.person,
                      hintText: "User Name",
                    ),

                    SizedBox(height: 10),

                    _buildLabel("Email"), SizedBox(height: 5),
                    // Email Input Field
                    _buildTextField(
                      controller: email,
                      icon: Icons.mail,
                      hintText: "Email",
                    ),

                    SizedBox(height: 10),
                    _buildLabel("Password"), SizedBox(height: 5),
                    // Password Input Field
                    _buildTextField(
                      controller: passWord,
                      icon: Icons.lock,
                      hintText: "Password",
                      obscureText: true,
                    ),

                    SizedBox(height: 10),
                    _buildLabel("Confirm Password"), SizedBox(height: 5),
                    // Confirm Password Input Field
                    _buildTextField(
                      controller: confirmPassword,
                      icon: Icons.lock,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),

                    SizedBox(height: 10),
                    _buildLabel("Phone Number"), SizedBox(height: 5),
                    // Phone Number Input Field
                    _buildTextField(
                      controller: phoneNumber,
                      icon: Icons.phone,
                      hintText: "Phone Number",
                    ),

                    SizedBox(height: 10),
                    _buildLabel("Location"), SizedBox(height: 5),
                    // Location Input Field
                    _buildTextField(
                      controller: location,
                      icon: Icons.phone,
                      hintText: "location",
                    ),

                    /*GestureDetector(
                      onTap: _navigateToMap,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: location,
                          icon: Icons.location_on,
                          hintText: "Tap to choose location",
                        ),
                      ),
                    ),*/
                    SizedBox(height: 35),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Sign up button pressed");
                          signup();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Color.fromRGBO(2, 173, 103, 1.0),
            width: 2,
          ),
        ),
      ),
    );
  }
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
