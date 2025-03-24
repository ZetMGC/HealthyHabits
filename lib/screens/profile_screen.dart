import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _resetApp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Очистка всех данных
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false, // Убираем все предыдущие экраны из истории
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _resetApp(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Сбросить приложение", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}