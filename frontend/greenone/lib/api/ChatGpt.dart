import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatGptApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/chat-gpt";
  User? user = FirebaseAuth.instance.currentUser;

  Future<Object> createMessage() async {
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
      return response.body;
    } else {
      return {'error': 'error'};
    }
  }
}