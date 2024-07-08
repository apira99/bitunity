import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'vitamin.dart';

class FruitIdentify extends StatefulWidget {
  const FruitIdentify({Key? key}) : super(key: key);

  @override
  State<FruitIdentify> createState() => _FruitIdentifyState();
}

class _FruitIdentifyState extends State<FruitIdentify> {
  String imageUrl = '';
  String additionalText = '';

  @override
  void initState() {
    super.initState();
    fetchFruitData();
  }

  Future<void> fetchFruitData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3002/animation'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          imageUrl = data['imageUrl'];
          additionalText = data['additionalText'];
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bgfi.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Fruit Image
          if (imageUrl.isNotEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(imageUrl, width: 200, height: 200),
                  SizedBox(height: 20),
                  Text(
                    additionalText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          else
            Center(
              child: CircularProgressIndicator(), // or a placeholder image
            ),

          // Button at the Bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Vitamin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF461555),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Benefits',
                  style: TextStyle(fontSize: 18, color: Color(0xFFFAF0E6)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}