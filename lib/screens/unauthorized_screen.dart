import 'package:flutter/material.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ошибка доступа'),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          'Пожалуйста, войдите в систему, чтобы продолжить.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
