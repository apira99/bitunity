import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivationScreen extends StatelessWidget {
  final String activationToken;

  ActivationScreen({required this.activationToken});

  Future<void> _activateAccount(BuildContext context) async {
    final response = await http.get(Uri.parse('http://localhost:3000/activate?token=$activationToken'));

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activation failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _activateAccount(context);

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
