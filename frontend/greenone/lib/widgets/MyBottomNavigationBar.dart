import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xffffffff),
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "달력",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "마이페이지",
        ),
      ],
      selectedItemColor: const Color(0xff3572EF),
      unselectedItemColor: const Color(0xff8F98A8),
    );
  }
}