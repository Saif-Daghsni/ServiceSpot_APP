import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passWord = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();


  Future signup() async{
    try {
        if(passWord.text.trim() == confirmPassword.text.trim()){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), 
          password: passWord.text.trim());
          Navigator.pushNamed(context, '/auth');
        }
        else{
          print("****confirmPassword error****");
        }
    } catch (e) {
      print("***********Signup error ************");
    }
  }

  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    passWord.dispose();
    confirmPassword.dispose();
    phoneNumber.dispose();
    super.dispose();
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/loginPage');
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Color.fromRGBO(2, 173, 103, 1.0),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Back to login",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(2, 173, 103, 1.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                
                    // User Name Input Field
                    _buildTextField(
                      controller: userName,
                      icon: Icons.person,
                      hintText: "User Name",
                    ),
                
                    SizedBox(height: 20),
                
                    // Email Input Field
                    _buildTextField(
                      controller: email,
                      icon: Icons.mail,
                      hintText: "Email",
                    ),
                
                    SizedBox(height: 20),
                
                    // Password Input Field
                    _buildTextField(
                      controller: passWord,
                      icon: Icons.lock,
                      hintText: "Password",
                      obscureText: true,
                    ),
                
                    SizedBox(height: 20),
                
                    // Confirm Password Input Field
                    _buildTextField(
                      controller: confirmPassword,
                      icon: Icons.lock,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                
                    SizedBox(height: 20),
                
                    // Phone Number Input Field
                    _buildTextField(
                      controller: phoneNumber,
                      icon: Icons.phone,
                      hintText: "Phone Number",
                    ),
                
                    SizedBox(height: 20),
                
                    _buildTextField(
                      controller: phoneNumber,
                      icon: Icons.location_on,
                      hintText: "Localisation",
                    ),
                
                    SizedBox(height: 35),
                
                    
                
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: signup,
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
