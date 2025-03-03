import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // For Base64 decoding
import 'dart:typed_data'; // For Uint8List (image data)

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({super.key});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  TextEditingController imageController = TextEditingController();
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch the current user's data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('workers').doc(user.uid).get();

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
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Edit Worker Profile",
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
      body: Center(
        child: imageBytes != null
            ? ClipOval(
                child: Image.memory(
                  imageBytes!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
