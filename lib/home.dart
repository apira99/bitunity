import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DatabaseHelper.dart';
import 'profile.dart';
import 'leaderboard.dart';
import 'game.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String childName = 'Eiden';
  String age = '7'; // Age as text, match your database schema
  int score = 0; // Example score, this should be retrieved from the database
  String profileImage = '';

  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
    _loadProfileImage();
  }

  Future<void> _loadProfileDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      if (email != null) {
        Database db = await _databaseHelper.database;
        Map<String, dynamic>? result = await _databaseHelper.getChildDetails(email);
        if (result != null) {
          setState(() {
            childName = result['childName'] ?? 'Unknown';
            age = result['age'] ?? 'Unknown'; // Handle age as text
            // Assuming score is retrieved from a different table or method
            // score = result['score'] ?? 0;
          });
        } else {
          print('No results found for email: $email'); // Debugging line
        }
      } else {
        print('No email found in SharedPreferences'); // Debugging line
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImage = prefs.getString('profileImage') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/homebg.png'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0), // Adjust left, top, and right padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fruity Kid heading
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Fruity Kid',
                    style: TextStyle(
                      color: Color(0xFF8E6797), // Text color
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Profile picture with padding
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Align profile section to the right
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture with specific padding
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: CircleAvatar(
                          radius: 40, // Adjust size as needed
                          backgroundColor: Color(0xFF8E6797),
                          child: profileImage.isEmpty
                              ? CircleAvatar(
                            radius: 38, // Adjust size as needed
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF8E6797),
                              size: 38,
                            ),
                          )
                              : CircleAvatar(
                            radius: 38, // Adjust size as needed
                            backgroundImage: FileImage(File(profileImage)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Name and Score in same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name with padding
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8),
                      child: Text(
                        childName,
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 20, // Font size for child's name
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Score label with specific padding
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        'Score',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18, // Font size for "Score"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Age and Score Number in same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Age with padding
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(
                        'Age: $age',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 18, // Font size for age
                        ),
                      ),
                    ),
                    // Score number with specific padding
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          '$score',
                          style: TextStyle(
                            color: Color(0xFF8E6797), // Text color
                            fontSize: 24, // Font size for score
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70, // Adjust the position above the bottom navigation bar
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 157,
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
                    Navigator.pushNamed(context, '/game'); // Navigate to game.dart file
                  },
                  child: Text('Start Game'),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Home is selected
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/leaderboard'); // Navigate to leaderboard.dart file
              break;
            case 2:
              Navigator.pushNamed(context, '/profile'); // Navigate to profile.dart file
              break;
          }
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85, // Adjust the height of the navigation bar container
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/navh.png'), // Background image for the bottom navigation bar
          fit: BoxFit.cover, // Choose BoxFit according to your design preference
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Transparent background
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: ImageIcon(
                AssetImage('assets/images/leaderboard.png'), // Example image for leaderboard
                size: 40,
              ),
            ),
            label: '', // Empty label to hide text
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: ImageIcon(
                AssetImage('assets/images/home.png'), // Example image for home
                size: 30,
              ),
            ),
            label: '', // Empty label to hide text
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: ImageIcon(
                AssetImage('assets/images/profile.png'), // Example image for profile
                size: 30,
              ),
            ),
            label: '', // Empty label to hide text
          ),
        ],
        currentIndex: currentIndex,
        //selectedItemColor: Color(0xFF461555),
        onTap: onTap,
      ),
    );
  }
}
