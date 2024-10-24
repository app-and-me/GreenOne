import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenone/api/User.dart';
import 'package:greenone/pages/main/LoginPage.dart';
import 'package:greenone/pages/profile/ManageAccountPage.dart';
import 'package:greenone/pages/profile/SetAlarmPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userDataFuture;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    userDataFuture = _loadUserData();
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    return await UserApi().getUserById(user!.uid);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildUmbrageWidget(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF898A8D)),
        ),
      );
    }

    if (snapshot.hasError) {
      return Text(
        "Error",
        style: GoogleFonts.roboto(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    if (!snapshot.hasData) {
      return Text(
        "N/A",
        style: GoogleFonts.roboto(
          color: const Color(0xFF898A8D),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    final int umbrage = snapshot.data!['data']['umbrage'];
    return Text(
      "$umbrage",
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        color: const Color(0xFF898A8D),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 36.49),
              Padding(
                padding: const EdgeInsets.only(right: 14.83),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/leaf.svg',
                      width: 29,
                      height: 29,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: userDataFuture,
                      builder: _buildUmbrageWidget,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.55),
              Image.asset(
                'assets/characters/1.png',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 79),
              _buildProfileCard(),
              const SizedBox(height: 51),
              _buildSettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 17.32, bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2E7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildProfileIcon(),
              const SizedBox(width: 10),
              Text(
                "${user?.displayName}",
                style: const TextStyle(
                  color: Color(0xFF8C8C8C),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          _buildPopupMenu()
        ],
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Stack(
      children: [
        Container(
          width: 42.22,
          height: 42.73,
          decoration: BoxDecoration(
            color: const Color(0x1401C674),
            shape: BoxShape.circle,
            image: user?.photoURL != null
                ? DecorationImage(image: NetworkImage(user!.photoURL!), fit: BoxFit.cover)
                : null
          ),
          child: user?.photoURL == null
              ? const Center(child: FlutterLogo(size: 24))
              : null,
        ),
      ],
    );
  }

  Widget _buildPopupMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: PopupMenuButton<String>(
        icon: SvgPicture.asset('assets/icons/more.svg'),
        onSelected: (String result) {
          switch (result) {
            case 'edit':
              break;
            case 'settings':
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('프로필 수정'),
          ),
          const PopupMenuItem<String>(
            value: 'settings',
            child: Text('설정'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SizedBox(
      width: 294,
      child: Column(
        children: [
          _buildSettingItem('알람 관리', () {
            Get.to(() => const SetAlarmPage());
          }, true),
          const SizedBox(height: 34),
          _buildSettingItem('계정 관리', () {
            Get.to(() => const ManageAccountPage());
          }, true),
          const SizedBox(height: 34),
          _buildSettingItem('로그아웃', () async {
            await _signOut();
            Get.offAll(() => const LoginPage());
          }, false),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, VoidCallback onTap, bool icon) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: title == "로그아웃" ? const Color(0xFFFF3131) : const Color(0xFF898A8D),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (icon)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFB9BBB9),
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}