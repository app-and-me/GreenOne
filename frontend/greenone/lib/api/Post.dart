import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PostApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/post";
  User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getPostById(String uid) async {
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
      return {'error': 'Post not found'};
    }
  }

  Future<Map<String, dynamic>> getPostByUserId(String uid) async {
    final url = Uri.parse('$baseUrl/user/$uid');
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
      return {'error': 'Post not found'};
    }
  }

  Future<http.Response> createPost(String authorId, String content, String title, File image) async {
    final url = Uri.parse(baseUrl);
    final idToken = await user?.getIdToken();

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $idToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['authorId'] = authorId;
    request.fields['content'] = content;
    request.fields['title'] = title;

    var fileStream = http.ByteStream(image.openRead());
    var length = await image.length();
    var multipartFile = http.MultipartFile(
      'image',
      fileStream,
      length,
      filename: path.basename(image.path),
    );
    request.files.add(multipartFile);

    final response = await request.send();

    if (response.statusCode == 201) {
      return http.Response.fromStream(response);
    } else {
      final responseBody = await http.Response.fromStream(response);
      print(responseBody.body);
      throw Exception('Failed to create post with image');
    }
  }

  Future<Map<String, dynamic>> updatePost(String uid, int age, int percent) async {
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