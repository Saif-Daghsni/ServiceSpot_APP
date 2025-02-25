import 'package:flutter/material.dart';

class ForgetpasswordPage extends StatefulWidget {
  const ForgetpasswordPage({super.key});

  @override
  State<ForgetpasswordPage> createState() => _ForgetpasswordPageState();
}

class _ForgetpasswordPageState extends State<ForgetpasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
      body: Column(
        children: [
          //1st box
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              color: Color.fromRGBO(
                2,
                173,
                103,
                1.0,
              ), //Color.fromRGBO(2, 173, 103, 1.0),
              padding: EdgeInsets.only(left: 25, right: 50, bottom: 20),
            ),
          ),
          //2st box
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 50, top: 60, right: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(235, 239, 238, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 20),
                  Text(
                    "Verification Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(3, 3, 3, 1),
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "We sent a verification code to your email , write it in the text filed",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(150, 150, 150, 1),
                    ),
                  ),

                  SizedBox(height: 30),

                  TextFormField(
                    obscureText: true, // Hides password input
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.shield),
                      hintText: "Write the code",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 2,
                        ),
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

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(2, 173, 103, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Verify",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //3st box
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              color: Color.fromRGBO(2, 173, 103, 1.0),
              padding: EdgeInsets.only(left: 25, right: 50, bottom: 20),
            ),
          ),
        ],
      ),
    );
  } 
}
