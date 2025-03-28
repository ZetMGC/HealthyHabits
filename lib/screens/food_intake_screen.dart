import 'package:flutter/material.dart';
import '../widgets/dropdown_datepicker.dart';
import '../widgets/AppBar.dart';

class FoodIntakeScreen extends StatelessWidget {
  const FoodIntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Добавить прием пищи",
        showBackButton: false, // Отключаем кнопку "Назад"
        trailingIcon: Icons.notifications,
        onTrailingPressed: () {
          print("Открыть настройки!");
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),
            Center(
              child: DropdownCardDatepicker(
                initialTitle: "Завтрак",
                initialDate: DateTime(2024, 3, 29), // Открыт сразу
              ),
            ),
          ]
        ),
      ),
    );
  }
}
