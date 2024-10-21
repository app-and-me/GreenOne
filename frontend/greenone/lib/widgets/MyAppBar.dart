import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget {
  final VoidCallback onNotificationPressed;

  const MyAppBar({
    super.key,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffEDEEF1),
      scrolledUnderElevation: 0,
      title: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'GreenOne',
              style: GoogleFonts.ptSans(
                color: const Color(0xFF01C674),
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/notifications.svg',
            width: 22.12,
            height: 24.73,
          ),
          onPressed: onNotificationPressed,
        ),
      ],
    );
  }
}