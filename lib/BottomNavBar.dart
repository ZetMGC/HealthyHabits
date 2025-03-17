import 'package:flutter/material.dart';

/// Виджет `CustomBottomNav` – кастомная нижняя панель навигации.
///
/// Этот виджет используется для отображения `BottomNavigationBar` с тремя вкладками:
/// - "Главная" (иконка `Icons.home`)
/// - "Привычки" (иконка `Icons.list`)
/// - "Профиль" (иконка `Icons.person`)
///
/// Виджет принимает два параметра:
/// - `currentIndex` – индекс текущей активной вкладки.
/// - `onTap` – функция, вызываемая при нажатии на вкладку.
class BottomNavBar extends StatelessWidget {
  /// Индекс текущей активной вкладки.
  final int currentIndex;

  /// Функция-обработчик нажатий на вкладки.
  final Function(int) onTap;

  /// Конструктор виджета `CustomBottomNav`.
  ///
  /// Требует обязательных параметров `currentIndex` и `onTap`.
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      /// Определяется три вкладки с иконками и подписями
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Привычки"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль"),
      ],
      /// Устанавливается текущий выбранный индекс
      currentIndex: currentIndex,
      /// Вызывается переданная функция `onTap`, когда пользователь нажимает на вкладку
      onTap: onTap,
    );
  }
}
