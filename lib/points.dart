import 'package:flutter/material.dart';
import 'feedback.dart'; // Import the Feedback screen
import 'leaderboard.dart'; // Import the Leaderboard screen

class Points extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/pbg.png'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Eiden Jessi',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF8E6797),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile.png'), // Replace with your profile picture
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:450.0),
                    child: Text(
                      'You earned 3560 points',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFF8E6797),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 229,
                            height: 51,
                            decoration: BoxDecoration(
                              color: Color(0xFF461555), // Use 0xFF for full opacity
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'Give feedback',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Leaderboard(),
                              ),
                            );
                          },
                          child: Container(
                            width: 229,
                            height: 51,
                            decoration: BoxDecoration(
                              color: Color(0xFF461555), // Use 0xFF for full opacity
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
