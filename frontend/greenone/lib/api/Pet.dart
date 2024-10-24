import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PetApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/pet";
  User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getPetById(String uid) async {
    final url = Uri.parse('$baseUrl/$uid');
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
      return {'error': 'Pet not found'};
    }
  }

  Future<http.Response> createPet(String masterId) async {
    final url = Uri.parse(baseUrl);
    final idToken = await user?.getIdToken();  
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: '''{
              "masterId": "$masterId"
            }''',
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> updatePet(String uid, int age, int percent) async {
    final url = Uri.parse('$baseUrl/$uid');
    final idToken = await user?.getIdToken();  
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: '''{
              "age": $age
              "percent": $percent
            }'''
    );


    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print(response.body);
      throw Exception('Failed to load user');
    }
  }
}