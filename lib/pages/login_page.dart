// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servicespot/pages/home_page1.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isEmailEmpty = false;
bool isPasswordEmpty = false;

bool falseEmail = false;
bool falsePassword = false;

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController myEmail = TextEditingController();
  TextEditingController myPassWord = TextEditingController();

  String errorMessageP = '';
  String errorMessageE = '';
  String errorMessageEE = '';
  String errorMessageV = '';

  void login() async {
    if (formstate.currentState!.validate()) {
      try {
        // Try signing in with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: myEmail.text.trim(),
              password: myPassWord.text.trim(),
            );

        User? user = userCredential.user;

        if (user != null) {
          // Navigate to the next screen after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage1()),
          );
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.code}"); // Print the error code

        if (e.code == 'user-not-found') {
          setState(() {
            errorMessageE = "No user found with this email.";
          });
          print("No user found with this email.");
        } else if (e.code == 'wrong-password') {
          setState(() {
            errorMessageP = "Incorrect password. Please try again.";
          });
          print("Incorrect password. Please try again.");
        } else {
          setState(() {
            errorMessageP =
                "An unknown error occurred. Please try again later.";
          });
          print("An unknown error occurred: ${e.message}");
        }
      } catch (e) {
        setState(() {
          errorMessageE = "An unexpected error occurred. Please try again.";
        });
      }
    }
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
                    "Hello1 !",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Welcome to ServiceSpot.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
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
              child: Form(
                key: formstate,
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            isEmailEmpty = true;
                            errorMessageE = "Email cannot be empty.";
                            errorMessageV = '';
                          } else if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value) &&
                              value.isNotEmpty) {
                            isEmailEmpty = true;
                            errorMessageV = "Write a valide email.";
                            errorMessageE = '';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          isEmailEmpty = false;
                        },
                        controller: myEmail,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color:
                                  isEmailEmpty
                                      ? Colors.red
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color:
                                  isEmailEmpty
                                      ? Colors.red
                                      : Color.fromRGBO(2, 173, 103, 1.0),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Error message for Email
                      if (errorMessageE.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            errorMessageE,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      if (errorMessageV.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            errorMessageV,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      SizedBox(height: 20),

                      // Password Input Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              isPasswordEmpty = true;
                            });
                            errorMessageP = "Password cannot be empty.";
                          }
                          return null;
                        },
                        controller: myPassWord,
                        obscureText: true, // Hides password input
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color:
                                  isPasswordEmpty
                                      ? Colors.red
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color:
                                  isPasswordEmpty
                                      ? Colors.red
                                      : Color.fromRGBO(2, 173, 103, 1.0),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Error message for Password
                      if (errorMessageP.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            errorMessageP,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      // Forgot Password Text (Aligned Right)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgetPasswordPage');
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
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              isEmailEmpty = false;
                              login();
                            }
                          },
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
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "or",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Social Media Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await signInwithGoogle();
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset("assets/Google.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
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
                                ),
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
          ),
        ],
      ),
    );
  }
}

signInwithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign out first to ensure the account chooser is displayed
  await googleSignIn.signOut();

  final GoogleSignInAccount? gUser = await googleSignIn.signIn();

  if (gUser == null) return;

  final GoogleSignInAuthentication gAuth = await gUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: gAuth.accessToken,
    idToken: gAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
