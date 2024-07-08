import 'package:flutter/material.dart';
import 'network_service.dart';
import 'fruit_model.dart';
import 'sugarcontent.dart';

class Fiber extends StatefulWidget {
  const Fiber({Key? key}) : super(key: key);

  @override
  State<Fiber> createState() => _FiberState();
}

class _FiberState extends State<Fiber> {
  late Future<Fruit> futureFruit;

  @override
  void initState() {
    super.initState();
    futureFruit = fetchFruitDetails('http://10.0.2.2:3000/fruits/1'); // Ensure this URL is correct
  }

  String _selectedTab = 'Fiber'; // Track the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
      Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fib.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),


          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 240), // Adjust padding as needed
            child: Center(
              child: FutureBuilder<Fruit>(
                future: futureFruit,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final fruit = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
                      children: [
                        Text(
                          'Fiber in ${fruit.name}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,  color: Color(0xFF461555)),
                        ),
                        SizedBox(height: 10, width: 160), // Adjust spacing as needed
                        Text(
                          fruit.fiberContent,
                          style: TextStyle(fontSize: 20,  color: Color(0xFF461555)),
                          softWrap: false,
                        ),
                      ],
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
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
                    MaterialPageRoute(builder: (context) => SugarContent()),
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
