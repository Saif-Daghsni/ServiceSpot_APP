import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassWord = TextEditingController();

  Future login() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: myEmail.text.trim(), 
      password: myPassWord.text.trim()
      );
  }


  @override
  void dispose() {
    myEmail.dispose();
    myPassWord.dispose();
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
                children: [
                  Text(
                    "Hello !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Welcome to our app.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2nd box
          Expanded(
            flex: 2,
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
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(2, 173, 103, 1.0),
                      ),
                    ),
                    SizedBox(height: 20),
                
                    // Email Input Field
                    TextField(
                      controller: myEmail,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Email",
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
                    ),
                
                    SizedBox(height: 20),
                
                    // Password Input Field
                    TextField(
                      controller: myPassWord,
                      obscureText: true, // Hides password input
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
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
                    ),
                
                    SizedBox(height: 5),
                
                    // Forgot Password Text (Aligned Right)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Add your forgot password logic here
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(2, 173, 103, 1.0),
                          ),
                        ),
                      ),
                    ),
                
                    SizedBox(height: 20),
                
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                
                    SizedBox(height: 15),
                
                    // Divider with "or"
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or", style: TextStyle(color: Colors.grey)),
                        ),
                        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                      ],
                    ),
                
                    SizedBox(height: 15),
                
                    // Social Media Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Button
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset("assets/Google.png"),
                          ),
                        ),
                
                        SizedBox(width: 30),
                
                        // Facebook Button
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image.asset("assets/facebook.png"),
                          ),
                        ),
                      ],
                    ),
                
                    SizedBox(height: 20),
                
                    // Sign-up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signupPage');
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Color.fromRGBO(2, 173, 103, 1.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
}
