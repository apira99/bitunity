import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fruit_model.dart';

Future<Fruit> fetchFruitDetails(String apiUrl) async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return Fruit.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load fruit details');
  }
}
