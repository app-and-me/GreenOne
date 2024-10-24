import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:greenone/api/User.dart';
import 'package:greenone/pages/main/LoginPage.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
        title: const Text(
          '계정 관리',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 0.05,
            letterSpacing: -0.41,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, top: 35),
          child: GestureDetector(
            onTap: () => {
              UserApi().deleteUser(FirebaseAuth.instance.currentUser!.uid),
              _signOut(),
              Get.offAll(() => const LoginPage()),
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/quit.svg'),
                const SizedBox(width: 8,),
                const Text(
                  '회원 탈퇴',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFF3131),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                  ),
                )
              ],
            )
          ) 
        )
      )
    );
  }
}