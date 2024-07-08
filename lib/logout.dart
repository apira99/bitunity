import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'profile.dart'; // Import the Profile page

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor: Color(0xFF461555), // Color for app bar background
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/lobg.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "Are you sure you want to logout?" text
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 72, 30, 0), // Adjust padding as needed
                  child: Text(
                    'Are You Sure Want To Logout?',
                    style: TextStyle(
                      color: Color(0xFF76587D), // Text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 72), // Spacing between text and buttons
                // "Yes" button
                SizedBox(
                  width: 186,
                  height: 41,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF461555), // Button background color
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop(); // Close the app on Android
                      } else if (Platform.isIOS) {
                        exit(0); // Close the app on iOS
                      }
                    },
                    child: Text('Yes'),
                  ),
                ),
                SizedBox(height: 20), // Spacing between buttons
                // "Go Back" button
                SizedBox(
                  width: 186,
                  height: 41,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF461555), // Button background color
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(email: '')), // Pass email parameter to ProfilePage
                      );
                    },
                    child: Text('Go Back'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
