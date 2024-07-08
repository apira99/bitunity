import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'signup.dart';
import 'login.dart';
import 'home.dart';
import 'game.dart';
import 'fruitidentify.dart';
import 'fruitdetails.dart';
import 'about.dart';
import 'logout.dart';
import 'leaderboard.dart'; // Import LeaderboardPage
import 'profile.dart'; // Import ProfilePage
import 'activationscreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notifyservice.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(FruityKidApp());
}


class FruityKidApp extends StatelessWidget {
  const FruityKidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruitykid',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomePage(),
        '/game': (context) => GameScreen(),
        '/fruitidentify': (context) => FruitIdentify(),
        '/about': (context) => AboutPage(),
        '/logout': (context) => LogoutPage(),
        '/leaderboard': (context) => Leaderboard(), // Add LeaderboardPage route
        '/profile': (context) => ProfilePage(email: ''), // Add ProfilePage route
        '/activate': (context) => ActivationScreen(
          activationToken: ModalRoute.of(context)!.settings.arguments as String,),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/front.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 38.4,
            top: 50,
            child: Text(
              'Fruitykid',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 38.4,
            top: 122,
            child: SizedBox(
              height: 22,
              child: Text(
                'Fruitful Health Companion',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  height: 1.1,
                  color: Color(0xFF461555),
                ),
              ),
            ),
          ),
          Positioned(
            top: 160.0,
            left: 98.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        fixedSize: Size(58, 58),
                      ),
                      child: Icon(Icons.login, size: 24),
                    ),
                    SizedBox(height: 5),
                    Text('Login', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        fixedSize: Size(58, 58),
                      ),
                      child: Icon(Icons.person_add, size: 24),
                    ),
                    SizedBox(height: 5),
                    Text('Signup', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}