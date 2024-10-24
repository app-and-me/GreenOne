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
      backgroundColor: const Color(0xffF8FAED),
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'GreenOne',
                style: GoogleFonts.ptSans(
                  color: const Color(0xFF01C674),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 28.03),
          child: IconButton(
            padding: EdgeInsets.zero, 
            icon: SvgPicture.asset(
              'assets/icons/notifications.svg',
              width: 22.42,
              height: 24.73,
            ),
            onPressed: onNotificationPressed,
          ),
        ),
      ],
    );
  }
}

