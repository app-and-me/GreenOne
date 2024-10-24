import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAED),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAED),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/left.svg',
            color: const Color(0xFFAAAAAA),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("알람 페이지")
      ),
    );
  }
}