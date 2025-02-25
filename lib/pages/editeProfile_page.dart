import 'package:flutter/material.dart';

class EditeprofilePage extends StatefulWidget {
  const EditeprofilePage({super.key});

  @override
  State<EditeprofilePage> createState() => _EditeprofilePageState();
}

class _EditeprofilePageState extends State<EditeprofilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
        title: const Align(
          alignment: Alignment.center, // Align app name to the left
          child: Text(
            "Edit profile",
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
            ), // Notification icon
            onPressed: () {
              Navigator.pushNamed(context, '/loginPage');
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(left: 40, right: 20, top: 30, bottom: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center text horizontally
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "User Name",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            // User Name Input Field
            _buildTextField(
              //controller: userName,
              icon: Icons.person,
              hintText: "User Name",
            ),

            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),
            // User Name Input Field
            _buildTextField(
              //controller: userName,
              icon: Icons.mail,
              hintText: "Email",
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),
            // Password Input Field
            _buildTextField(
              //controller: userName,
              icon: Icons.lock,
              hintText: " password",
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Number",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),
            // Phone Number Input Field
            _buildTextField(
              //controller: phoneNumber,
              icon: Icons.phone,
              hintText: "phoneNumber",
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Localisation",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),
            // Phone Number Input Field
            _buildTextField(
              //controller: phoneNumber,
              icon: Icons.location_on,
              hintText: "Localisation",
            ),
            SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/editeProfileWorker');
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
    );
  }
}

Widget _buildTextField({
  //required TextEditingController controller,
  required IconData icon,
  required String hintText,
  bool obscureText = false,
}) {
  return TextField(
    //controller: controller,
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
