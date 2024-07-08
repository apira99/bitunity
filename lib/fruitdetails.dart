import 'package:flutter/material.dart';

class fruitdetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrient in fruits'),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/nutrient.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered text

        ],
      ),
    );
  }
}
