import 'package:flutter/material.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("메시지 리스트 페이지"),
    );
  }
}