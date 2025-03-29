import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddservicePage extends StatefulWidget {
  const AddservicePage({super.key});

  @override
  State<AddservicePage> createState() => _AddservicePageState();
}

class _AddservicePageState extends State<AddservicePage> {
  File? selectedImage;
  String? imageBase64;

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

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            userName.text = userData['username'] ?? 'No Username';
            phoneNumber.text = userData['phone'] ?? 'No Phone Number';
            email.text = userData['email'] ?? 'No Email';
            location.text = userData['location'] ?? 'No Location';
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _saveData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('workers').doc(user.uid).set({
          'username': userName.text,
          'phone': phoneNumber.text,
          'email': email.text,
          'service': serviceController.text,
          'price': priceController.text,
          'location': location.text,
          'imageBase64': imageBase64 ?? '',
          'userId': user.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Service saved successfully!")),
        );
        Navigator.pushNamed(context, '/auth');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save service: $e")));
      }
    }
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      File imageFile = File(file.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        selectedImage = imageFile;
        imageBase64 = base64Encode(imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 239, 238, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 173, 103, 1.0),
        title: const Text("Add Service", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/loginPage'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLabel("The service"),
              _buildTextField(serviceController, Icons.handyman, "Write your service"),
              _buildLabel("The price per hour"),
              _buildTextField(priceController, Icons.attach_money, "The price per hour"),
              const SizedBox(height: 50),
              Text("Add a photo "),
              selectedImage != null ? Image.file(selectedImage!, width: 100, height: 100, fit: BoxFit.cover) : const Text('No image selected'),
              const SizedBox(height: 20),
              _buildButton("Adddd Photos", _pickImage),
              const SizedBox(height: 40),
              _buildButton("Save", _saveData, isPrimary: true),
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
        child: Text(text, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
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
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Color.fromRGBO(2, 173, 103, 1.0), width: 2)),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {bool isPrimary = false}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color.fromRGBO(2, 173, 103, 1.0) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: isPrimary ? Colors.transparent : const Color.fromRGBO(2, 173, 103, 1.0), width: 2),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 18, color: isPrimary ? Colors.white : const Color.fromRGBO(2, 173, 103, 1.0))),
      ),
    );
  }
}