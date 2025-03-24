import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
          child: Icon(Icons.home, size: 45, color: currentIndex == 0 ? Colors.white : Colors.red),
        ),
        Transform.scale(
          scale: 0.8,
          child: Icon(Icons.calendar_today, size: 45, color: currentIndex == 1 ? Colors.white : Colors.red),
        ),
        Transform.scale(
          scale: 0.8,
          child: Icon(Icons.add, size: 45, color: currentIndex == 2 ? Colors.white : Colors.red),
        ),
        Transform.scale(
          scale: 0.8,
          child: Icon(Icons.description, size: 45, color: currentIndex == 3 ? Colors.white : Colors.red),
        ),
        Transform.scale(
          scale: 0.8,
          child: Icon(Icons.group, size: 45, color: currentIndex == 4 ? Colors.white : Colors.red),
        ),
      ],
      onTap: onTap,
    );
  }
}
