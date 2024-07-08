import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> backgroundImages; // Add this line

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.backgroundImages, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/lnav.png'),
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
              child: Image.asset(
                backgroundImages[0], // Use the provided background image
                width: 40,
                height: 40,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                backgroundImages[1], // Use the provided background image
                width: 30,
                height: 30,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(
                backgroundImages[2], // Use the provided background image
                width: 30,
                height: 30,
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
