import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DatabaseHelper.dart';
import 'about.dart';
import 'logout.dart';
import 'reminderscreen.dart';
import 'fruitdetails.dart';

class ProfilePage extends StatefulWidget {



  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String _profileImagePath = '';
  String _childName = 'Child Name';
  String _parentEmail = '';

  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadChildDetails();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImage') ?? '';
      if (_profileImagePath.isNotEmpty) {
        _profileImage = File(_profileImagePath);
      }
    });
  }

  Future<void> _loadChildDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      if (email != null) {
        Map<String, dynamic>? result = await _databaseHelper.getChildDetails(email);
        if (result != null) {
          setState(() {
            _childName = result['childName'] ?? 'Unknown';
            _parentEmail = result['parentEmail'] ?? email;
          });
        } else {
          print('No results found for email: $email');
        }
      } else {
        print('No email found in SharedPreferences');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
      setState(() {
        _profileImagePath = pickedFile.path;
        _profileImage = File(_profileImagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 39.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E6797),
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: _selectProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF8E6797),
                      child: _profileImage == null
                          ? CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFF8E6797),
                        ),
                      )
                          : CircleAvatar(
                        radius: 48,
                        backgroundImage: FileImage(_profileImage!),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _childName,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8E6797),
                    ),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  ProfileMenuItem(
                    icon: Icons.details,
                    text: 'Nutrient details',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => fruitdetails()),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications,
                    text: 'Push Notifications',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReminderScreen(title: '',)),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.info,
                    text: 'About',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogoutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/home');
              break;
            case 2:
            // This is the current page
              break;
          }
        },
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback press;
  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onPressed: press,
        child: Row(
          children: <Widget>[
            Icon(icon, color: Color(0xFF8E6797)),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Color(0xFF8E6797)),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF8E6797)),
          ],
        ),
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
      height: 85,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pnav.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: ImageIcon(
                AssetImage('assets/images/leaderboard.png'),
                size: 40,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: ImageIcon(
                AssetImage('assets/images/home.png'),
                size: 30,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: ImageIcon(
                AssetImage('assets/images/profile.png'),
                size: 30,
              ),
            ),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF461555),
        onTap: onTap,
      ),
    );
  }
}
