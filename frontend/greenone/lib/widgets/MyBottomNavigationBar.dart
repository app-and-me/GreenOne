import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16.0), 
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(95),
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                iconPath: 'assets/icons/home.svg',
                index: 0,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/calendar.svg',
                index: 1,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/list.svg',
                index: 2,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/profile.svg',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SvgPicture.asset(
          iconPath,
          color: isSelected
              ? const Color(0xFF01C674)
              : const Color(0xFFCCCCCC),
          height: 24.0,
          width: 24.0
        ),
      ),
    );
  }
}