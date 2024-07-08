import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Map<String, dynamic>> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Replace with the correct URL for your environment
      var response = await http.get(Uri.parse('http://10.0.2.2:3001/leaderboard'));

      if (response.statusCode == 200) {
        // Print the response body for debugging
        print('Response body: ${response.body}');

        setState(() {
          leaderboardData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
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
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: leaderboardData.isEmpty
          ? Center(
        child: CircularProgressIndicator(), // Show loading indicator while fetching data
      )
          : ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(leaderboardData[index]['imageUrl']),
              onBackgroundImageError: (error, stackTrace) {
                print('Error loading image: $error'); // Print image loading errors
              },
            ),
            title: Text(leaderboardData[index]['name']),
            subtitle: Text('Score: ${leaderboardData[index]['score']}'),
          );
        },
      ),
    );
  }
}
