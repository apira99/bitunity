import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

// Function to generate a random salt
String generateSalt([int length = 16]) {
  final Random _random = Random.secure();
  final List<int> _saltBytes = List<int>.generate(length, (_) => _random.nextInt(256));
  return base64Url.encode(_saltBytes);
}

// Function to hash the password with the salt
String hashPassword(String password, String salt) {
  final key = utf8.encode(password + salt);
  final digest = sha256.convert(key);
  return digest.toString();
}
