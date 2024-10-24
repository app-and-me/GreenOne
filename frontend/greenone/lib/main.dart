import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:greenone/firebase_options.dart';
import 'package:greenone/pages/main/CalendarPage.dart';
import 'package:greenone/pages/main/HomePage.dart';
import 'package:greenone/pages/main/LoginPage.dart';
import 'package:greenone/pages/MainPage.dart';
import 'package:greenone/pages/main/MessageListPage.dart';
import 'package:greenone/pages/main/ProfilePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/config/.env');

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
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/message-list', page: () => const MessageListPage()),
      ],
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
    );
  }
}