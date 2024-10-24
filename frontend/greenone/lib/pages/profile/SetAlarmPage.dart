import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SetAlarmPage extends StatefulWidget {
  const SetAlarmPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SetAlarmPageState createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {
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
        title: const Text(
          '알람 설정',
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
      body: const Center(
        child: Text("알람 설정 페이지")
      ),
    );
  }
}