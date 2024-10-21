import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenone/pages/CalendarPage.dart';
import 'package:greenone/pages/HomePage.dart';
import 'package:greenone/pages/LoginPage.dart';
import 'package:greenone/pages/MainPage.dart';
import 'package:greenone/pages/ProfilePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/calendar', page: () => const CalendarPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/login', page: () => const LoginPage())
      ],
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}