import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:greenone/api/Post.dart';
import 'package:greenone/widgets/MessageCard.dart';
import 'package:intl/intl.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  late Future<Map<String, dynamic>> postDataFuture;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    postDataFuture = _loadPostData();
  }

  Future<Map<String, dynamic>> _loadPostData() async {
    return await PostApi().getPostByUserId(user!.uid);
  }

  DateTime parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) return DateTime.now();
    
    if (createdAt is Map) {
      final seconds = (createdAt['_seconds'] as num).toInt();
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    } else if (createdAt is Timestamp) {
      return createdAt.toDate();
    } else if (createdAt is String) {
      return DateTime.parse(createdAt);
    }
    
    return DateTime.now();
  }
  
  Future<String> convertUrl(String original) async {
    try {
      String url =  await FirebaseStorage.instance.ref().child(original.split('/').last).getDownloadURL();
      return url;
    } catch (error) {
      return 'Error: $error';
    }
  }

  Widget _buildMessageCard(Map<String, dynamic> post) {
    return FutureBuilder<String>(
      future: convertUrl(post['imageUrl']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading image URL'),
          );
        }
        
        return MessageCardWithImage(
          title: post['title'],
          date: DateFormat('yyyy.MM.dd a h:mm', 'ko').format(
            parseCreatedAt(post['createdAt'])
          ),
          imageUrl: snapshot.data ?? '',
          content: post['content']
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAED),
        titleSpacing: 29.88,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '기록',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 22,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 26, top: 23.5),
          child: FutureBuilder<Map<String, dynamic>>(
            future: postDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading messages\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            postDataFuture = _loadPostData();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              if (snapshot.data!['status'] == 404) {
                return Container();
              }

              List<dynamic> posts = snapshot.data!['data'];
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) => _buildMessageCard(posts[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}