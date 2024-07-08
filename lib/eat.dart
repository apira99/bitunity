import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'points.dart'; // Import the Points class

class Eat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lets eat',
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
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the camera
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  void _stopCameraAndNavigate() {
    _controller.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Points(), // Navigate to Points page
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
                Navigator.pop(context);
              },
              child: Container(
                width: 30,
                height: 30,
                child: Image.asset('assets/images/back.png'),
              ),
            ),
          ),
          Positioned(
            top: 77.7,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Lets eat',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: Color(0xFF24032C), // Changed color to 24032C
                ),
                textAlign: TextAlign.center, // Center align the text
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
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return ClipOval(
                      child: CameraPreview(_controller),
                    );
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 122,
            top: 743,
            child: GestureDetector(
              onTap: _stopCameraAndNavigate,
              child: Container(
                width: 186,
                height: 41,
                decoration: BoxDecoration(
                  color: Color(0xFF461555),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Center(
                  child: Text(
                    'Stop',
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
          ),
        ],
      ),
    );
  }
}
