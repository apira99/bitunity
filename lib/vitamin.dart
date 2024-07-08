import 'package:flutter/material.dart';
import 'network_service.dart';
import 'fruit_model.dart'; // Assuming you have a Fruit model defined
import 'fiber.dart';

class Vitamin extends StatefulWidget {
  const Vitamin({Key? key}) : super(key: key);

  @override
  State<Vitamin> createState() => _VitaminState();
}

class _VitaminState extends State<Vitamin> {
  late Future<Fruit> futureFruit;

  @override
  void initState() {
    super.initState();
    futureFruit = fetchFruitDetails('http://10.0.2.2:3000/fruits/1'); // Fetch the fruit details from the backend
  }

  String _selectedTab = 'Vitamin'; // Track the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/vb.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 240), // Adjust padding as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
              children: [
                // Align vitamin details above with padding
                Text(
                  'Vitamins in Apple',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF461555)), // Change text color to purple
                ),
                SizedBox(height: 10,width:160), // Adjust spacing as needed
                FutureBuilder<Fruit>(
                  future: futureFruit,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final fruit = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align vitamin details to the start (left)
                        children: [
                          Text(
                            fruit.vitamins,
                            style: TextStyle(fontSize: 16, color: Color(0xFF461555)), // Change text color to purple
                            softWrap: false,
                          ),
                        ],
                      );
                    } else {
                      return Text('No data available');
                    }
                  },
                ),
              ],
            ),
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
                    MaterialPageRoute(builder: (context) => Fiber()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF461555), // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Color(0xFFFAF0E6)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text) {
    final bool isSelected = _selectedTab == text;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _selectedTab = text;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = text;
          });
        },
        child: Container(
          width: 108, // Set width to ensure equal distribution within 328 width container
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF76587D) : Colors.white,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF9DA8C3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
