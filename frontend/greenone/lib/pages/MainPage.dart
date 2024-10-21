import 'package:flutter/material.dart';
import 'package:greenone/pages/main/CalendarPage.dart';
import 'package:greenone/pages/main/HomePage.dart';
import 'package:greenone/pages/main/MessageListPage.dart';
import 'package:greenone/pages/main/ProfilePage.dart';
import 'package:greenone/pages/notification/NotificationPage.dart';
import 'package:greenone/widgets/MyAppBar.dart';
import 'package:greenone/widgets/MyBottomNavigationBar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final pages = [
    const HomePage(),
    const CalendarPage(),
    const MessageListPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEEF1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          onNotificationPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}