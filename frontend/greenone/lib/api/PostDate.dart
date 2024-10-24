import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PostDateApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/post-date";
  User? user = FirebaseAuth.instance.currentUser;

  Future<http.Response> createPostDate(String userId, String date, bool value) async {
    final url = Uri.parse("$baseUrl/$date");
    final idToken = await user?.getIdToken();  
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: '''{
              "value": $value
            }''',
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to create post date');
    }
  }

  Future<Map<String, dynamic>> getUserById(String uid) async {
    final url = Uri.parse(baseUrl);
    final idToken = await user?.getIdToken();  
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {'error': 'PostDate not found'};
    }
  }
}