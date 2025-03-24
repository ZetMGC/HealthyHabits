import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent, // Делаем фон полностью прозрачным
      color: Colors.white, // Цвет самой панели
      buttonBackgroundColor: Colors.red, // Фон за кнопками теперь белый
      height: 75,
      index: currentIndex,
      items: [
        Transform.scale(
          scale: 0.8,
          child: SvgPicture.asset(
            currentIndex == 0
                ? 'assets/icons/active_home.svg'
                : 'assets/icons/inactive_home.svg',
            width: 30,
            height: 30,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: SvgPicture.asset(
            currentIndex == 1
                ? 'assets/icons/active_calendar.svg'
                : 'assets/icons/inactive_calendar.svg',
            width: 30,
            height: 30,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: SvgPicture.asset(
            currentIndex == 2
                ? 'assets/icons/active_add.svg'
                : 'assets/icons/inactive_add.svg',
            width: 30,
            height: 30,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: SvgPicture.asset(
            currentIndex == 3
                ? 'assets/icons/active_chat.svg'
                : 'assets/icons/inactive_chat.svg',
            width: 30,
            height: 30,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: SvgPicture.asset(
            currentIndex == 4
                ? 'assets/icons/active_profile.svg'
                : 'assets/icons/inactive_profile.svg',
            width: 30,
            height: 30,
          ),
        ),
      ],
      onTap: onTap,
    );
  }
}
