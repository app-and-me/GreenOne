import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenone/api/Pet.dart';
import 'package:greenone/api/User.dart';
import 'package:greenone/pages/MainPage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFF8FAED),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 130),
                _buildLogoSection(),
                const Spacer(),
                _buildLoginButton(),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: SvgPicture.asset('assets/icons/logo.svg')
            ),
            const SizedBox(width: 8),
            Text(
              'GreenOne',
              style: GoogleFonts.ptSans(
                color: const Color(0xFF01C674),
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
  return SizedBox(
    width: 306,
    child: ElevatedButton(
      onPressed: _isSigningIn ? null : _handleGoogleSignIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFAAAAAA),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: _isSigningIn
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Color(0xFFAAAAAA),
                strokeWidth: 2,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/google.svg'),
                  const SizedBox(width: 31,),
                  const Text(
                  '구글 계정으로 로그인',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
    ),
  );
}


  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isSigningIn = true);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign In was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      String uid = user!.uid;

      Map<String, dynamic> userResponse = await UserApi().getUserById(uid);

      if (userResponse['status'] == 404) {
        UserApi().createUser(uid).then(
          (response) => PetApi().createPet(uid)
        );
      }
      
      Get.offAll(() => const MainPage());
    } catch (e) {
      print('Error during Google sign in: $e');
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
}