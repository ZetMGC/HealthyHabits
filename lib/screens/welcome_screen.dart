import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF5FFFA),
            Color(0xFFF0ECFC),
            Color(0xFFF0ECFC),
            Color(0xFFBDBECC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 150), // Отступ сверху
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // 80% ширины экрана
                    child: Image.asset(
                      "assets/images/bg.png",
                      fit: BoxFit.contain, // Не растягивает картинку
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFE14E31)),
                    child: const Center(child: Text('Алгоритмы Успеха')),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    width: 261,
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(
                          0xFF686868)),
                      child: const Center(child: Text('Это современное решение здесь, чтобы помочь тебе лучше следить за своими задачами', textAlign: TextAlign.center,)),
                    ),
                  ),
                  const SizedBox(height: 35),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE14E31), fixedSize: const Size(350, 50), shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _completeWelcome(context),
                      child: DefaultTextStyle.merge(style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      child: const Text("Начнем")
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
