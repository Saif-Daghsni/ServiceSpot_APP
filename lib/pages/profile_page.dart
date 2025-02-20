import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromRGBO(235, 239, 238, 1.0),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 40, right: 50),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(2, 173, 103, 1.0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                  Icons.person, 
                  color: Colors.white,
                  size: 90,
                  ),

                  SizedBox(width: 10),

                  SizedBox(
                    width: 140,
                    height: 90,
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                      children: [
                        Text(
                          "User Name",
                          style: TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "51019312",
                          style: TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(left: 50, top: 40, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/editeProfilePage');
                  },            
                  child : Container(
                  height: 55,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the container
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(125, 125, 125, 1.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns text & arrow
                    children: [
                      Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white), // Icon before text
                          SizedBox(width: 15), // Space between icon and text
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                     ),
                      Icon(Icons.chevron_right, color: Colors.white), // Small arrow on the right
                    ],
                  ),
                ),
                ),
                
                SizedBox(height: 10),
                  
                  GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/addServicePage');
                  },            
                  child : Container(
                  height: 55,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the container
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(125, 125, 125, 1.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns text & arrow
                    children: [
                      Row(
                        children: [
                          Icon(Icons.handyman, color: Colors.white), // Icon before text
                          SizedBox(width: 15), // Space between icon and text
                          Text(
                            "Add service",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                     ),
                      Icon(Icons.chevron_right, color: Colors.white), // Small arrow on the right
                    ],
                  ),


                  
                ),

                ),


                 SizedBox(height: 10),
                  
                  GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/settingsPage');
                  },            
                  child : Container(
                  height: 55,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the container
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(125, 125, 125, 1.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns text & arrow
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings, color: Colors.white), // Icon before text
                          SizedBox(width: 15), // Space between icon and text
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                     ),
                      Icon(Icons.chevron_right, color: Colors.white), // Small arrow on the right
                    ],
                  ),


                  
                ),
                  ),



                 SizedBox(height: 10),
                 Spacer(), 
                 GestureDetector(
                  onTap: () {
                  Navigator.pushNamed(context, '/loginPage');
                 },



                //Logout
               child: GestureDetector(
                
                onTap:(){
                  FirebaseAuth.instance.signOut();
                },
                 child: Container(
                    height: 55,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(211, 47, 47,1.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns text & arrow
                      children: [
                        Row(
                          children: [
                            Icon(Icons.logout, color: Colors.white), // Icon before text
                            SizedBox(width: 15), // Space between icon and text
                            Text(
                              "Logout ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                       ),
                        Icon(Icons.chevron_right, color: Colors.white), // Small arrow on the right
                      ],
                    ), 
                  ),
               ),
              ),
                SizedBox(height: 10),

                ],
              ),
            ),
          )
        ],
      )

    );
  }
}