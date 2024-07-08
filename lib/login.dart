import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Import the main screen
import 'home.dart';
import 'signup.dart';
import 'forgotpassword.dart'; // Import the forgot password screen
import 'DatabaseHelper.dart';
import 'fruitdetails.dart'; // Import the profile details screen

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context, String email, String password) async {
    bool loginSuccessful = await DatabaseHelper().validateLogin(email, password);
    if (loginSuccessful) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomeScreen
      );
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Incorrect email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Log In Title
          Positioned(
            left: 179,
            top: 66,
            child: Text(
              'Log In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(69, 21, 85, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Main Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 34.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 140),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(142, 103, 151, 1),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter your details to proceed.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(69, 21, 85, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF76587D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'example@example.com',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(69, 21, 85, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF76587D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '●●●●●●●●',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                      obscuringCharacter: '•',
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 186,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(0xFF461555),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          String email = emailController.text;
                          String password = passwordController.text;

                          if (email.isNotEmpty && password.isNotEmpty) {
                            await _login(context, email, password);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter email and password')),
                            );
                          }
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xFF461555)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(color: Color(0xFF461555)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 186,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Color(0xFF461555),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FruityKidApp()), // Navigate to MainScreen
                          );
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
