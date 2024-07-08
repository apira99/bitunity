import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'emailsending.dart';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fruitykiddb.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE signup (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      parentEmail TEXT,
      childName TEXT,
      parentMobile TEXT,
      age TEXT,
      salt TEXT,
      hashedPassword TEXT,
      isActive INTEGER DEFAULT 0
    )
  ''');

    await db.execute('''
      CREATE TABLE feedback(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parentEmail TEXT,
        rating INTEGER,
        feedback TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parentEmail TEXT,
        reminderTime TEXT
      ) 
    ''');
  }

  Future<int> insertSignupDetails(Map<String, dynamic> signupDetails) async {
    Database db = await database;

    String salt = _generateSalt();
    String hashedPassword = _hashPassword(signupDetails['password'], salt);
    String activationToken = _generateActivationToken(); // Generate activation token

    Map<String, dynamic> dataToInsert = {
      'parentEmail': signupDetails['parentEmail'],
      'childName': signupDetails['childName'],
      'parentMobile': signupDetails['parentMobile'],
      'age': signupDetails['age'],
      'salt': salt,
      'hashedPassword': hashedPassword,
      'activationToken': activationToken, // Include activation token in the data to insert
      'isActive': 0, // Account is initially inactive
    };

    try {
      int result = await db.insert(
        'signup',
        dataToInsert,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      if (result != -1) {
        // Send activation token to backend to create the activation token entry
        bool tokenCreated = await _createActivationToken(signupDetails['parentEmail'], activationToken);
        if (!tokenCreated) {
          print('Error: Failed to create activation token on the backend');
        } else {
          // Send activation email with activation link
          bool emailSent = await _sendActivationEmail(signupDetails['parentEmail'], activationToken);
          if (!emailSent) {
            print('Error: Failed to send activation email');
          }
        }
      }
      return result;
    } catch (e) {
      print('Error inserting signup details: $e');
      return -1;
    }
  }

  // Function to create activation token on the backend
  Future<bool> _createActivationToken(String parentEmail, String activationToken) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3003/create-activation-token'),
      body: {'parentEmail': parentEmail, 'activationToken': activationToken},
    );

    return response.statusCode == 200;
  }

  String _generateActivationToken() {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(32, (index) => charset[random.nextInt(charset.length)]).join();
  }

  Future<bool> _sendActivationEmail(String parentEmail, String activationToken) async {
    String activationLink = 'http://10.0.2.2:3003/activate?token=$activationToken';
    // Construct your email content with the activationLink

    try {
      bool emailSent = await EmailService.sendActivationEmail(parentEmail, activationLink);
      return emailSent;
    } catch (e) {
      print('Error sending activation email: $e');
      return false; // Handle email sending failure
    }
  }

  Future<Map<String, dynamic>?> getChildDetails(String parentEmail) async {
    Database db = await database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'signup',
        columns: ['childName', 'parentEmail', 'parentMobile', 'age', 'salt', 'hashedPassword'],
        where: 'parentEmail = ?',
        whereArgs: [parentEmail],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error getting child details: $e');
      return null;
    }
  }

  Future<bool> validateLogin(String email, String password) async {
    Database db = await database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'signup',
        where: 'parentEmail = ?',
        whereArgs: [email],
      );
      if (result.isEmpty) {
        print('Error: No user found with this email');
        return false;
      }

      Map<String, dynamic> userData = result.first;

      // Print activation status for debugging purposes
      print('Debug: Account activation status: ${userData['isActive']}');

      String salt = userData['salt'];
      String hashedPassword = userData['hashedPassword'];
      print('Debug: Stored salt: $salt');
      print('Debug: Stored hashed password: $hashedPassword');
      String inputHashedPassword = _hashPassword(password, salt);
      print('Debug: Input hashed password: $inputHashedPassword');

      return hashedPassword == inputHashedPassword;
    } catch (e) {
      print('Error validating login: $e');
      return false;
    }
  }

  String _generateSalt() {
    final random = Random.secure();
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(16, (index) => charset[random.nextInt(charset.length)]).join();
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> emailExists(String email) async {
    Database db = await database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'signup',
        where: 'parentEmail = ?',
        whereArgs: [email],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if email exists: $e');
      return false;
    }
  }

  Future<int> updatePassword(String parentEmail, String newPassword) async {
    Database db = await database;
    try {
      String salt = _generateSalt();
      String hashedPassword = _hashPassword(newPassword, salt);
      return await db.update(
        'signup',
        {'salt': salt, 'hashedPassword': hashedPassword},
        where: 'parentEmail = ?',
        whereArgs: [parentEmail],
      );
    } catch (e) {
      print('Error updating password: $e');
      return -1;
    }
  }

  Future<int> insertFeedback(String parentEmail, int rating, String feedback) async {
    Database db = await database;
    try {
      return await db.insert('feedback', {
        'parentEmail': parentEmail,
        'rating': rating,
        'feedback': feedback,
      });
    } catch (e) {
      print('Error inserting feedback: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllFeedback() async {
    Database db = await database;
    try {
      return await db.query('feedback');
    } catch (e) {
      print('Error getting all feedback: $e');
      return [];
    }
  }

  Future<int> insertReminder(String parentEmail, String reminderTime) async {
    Database db = await database;
    try {
      return await db.insert(
        'reminders',
        {
          'parentEmail': parentEmail,
          'reminderTime': reminderTime,
        },
      );
    } catch (e) {
      print('Error inserting reminder: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getReminders(String parentEmail) async {
    Database db = await database;
    try {
      return await db.query(
        'reminders',
        where: 'parentEmail = ?',
        whereArgs: [parentEmail],
      );
    } catch (e) {
      print('Error getting reminders: $e');
      return [];
    }
  }

  Future<int> updateReminder(String parentEmail, String oldReminderTime, String newReminderTime) async {
    Database db = await database;
    try {
      return await db.update(
        'reminders',
        {
          'reminderTime': newReminderTime,
        },
        where: 'parentEmail = ? AND reminderTime = ?',
        whereArgs: [parentEmail, oldReminderTime],
      );
    } catch (e) {
      print('Error updating reminder: $e');
      return -1;
    }
  }

  Future<int> activateAccount(String activationToken) async {
    Database db = await database;
    try {
      // Fetch the email associated with the activation token
      List<Map<String, dynamic>> result = await db.query(
        'signup',
        columns: ['parentEmail'],
        where: 'activationToken = ?',
        whereArgs: [activationToken],
      );

      if (result.isNotEmpty) {
        String parentEmail = result.first['parentEmail'];
        // Update the signup table to activate the account
        return await db.update(
          'signup',
          {'isActive': 1},
          where: 'parentEmail = ?',
          whereArgs: [parentEmail],
        );
      } else {
        print('Error: Activation token not found.');
        return -1;
      }
    } catch (e) {
      print('Error activating account: $e');
      return -1;
    }
  }
}
