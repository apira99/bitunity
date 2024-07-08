import 'package:flutter/material.dart';
import 'home.dart'; // Import your home screen file
import 'fruitidentify.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Capture App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CaptureFruitScreen(),
    );
  }
}

class CaptureFruitScreen extends StatefulWidget {
  @override
  _CaptureFruitScreenState createState() => _CaptureFruitScreenState();
}

class _CaptureFruitScreenState extends State<CaptureFruitScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _navigateToFruitIdentify() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FruitIdentify(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/gbg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage (),
                  ),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                child: Image.asset('assets/images/back.png'),
              ),
            ),
          ),
          Positioned(
            top: 78,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Let\'s capture the fruit',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: Color(0xFF24032C),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            left: 27,
            top: 283,
            child: Container(
              width: 371,
              height: 373,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: _image == null
                ? SizedBox(
              width: 70.6,
              height: 54,
              child: Image.asset(
                'assets/images/cam.png',
              ),
            )
                : Image.file(
              _image!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 122,
            top: 743,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _openCamera,
                  child: Container(
                    width: 186,
                    height: 41,
                    decoration: BoxDecoration(
                      color: Color(0xFF461555),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Center(
                      child: Text(
                        'Tab Camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFFFAF0E6),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space between the buttons
                GestureDetector(
                  onTap: _navigateToFruitIdentify,
                  child: Container(
                    width: 186,
                    height: 41,
                    decoration: BoxDecoration(
                      color: Color(0xFF461555),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFFFAF0E6),
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
    );
  }
}
