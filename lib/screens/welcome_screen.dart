import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _completeWelcome(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Добро пожаловать!", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _completeWelcome(context),
              child: const Text("Начать"),
            ),
          ],
        ),
      ),
    );
  }
}
