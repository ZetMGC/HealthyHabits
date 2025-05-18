import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const HorizontalDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  late DateTime selectedDate;
  late List<DateTime> fixedDates;
  final ScrollController _scrollController = ScrollController();

  final double itemWidth = 80; // примерная ширина одной ячейки
  final double separatorWidth = 12;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;

    // 10 дней назад + сегодня + 10 вперёд
    fixedDates = List.generate(
      21,
      (i) => widget.initialDate.subtract(Duration(days: 10 - i)),
    );

    // Прокрутка к текущей дате
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(10); // центральный индекс
    });
  }

  void _scrollToIndex(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset = index * (itemWidth + separatorWidth) - screenWidth / 2 + itemWidth / 2;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: fixedDates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = fixedDates[index];
          final isSelected = selectedDate.year == date.year &&
              selectedDate.month == date.month &&
              selectedDate.day == date.day;

          return GestureDetector(
            onTap: () {
              setState(() => selectedDate = date);
              widget.onDateSelected(date);
            },
            child: AnimatedContainer(
              width: itemWidth, // фиксируем ширину
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE14E31) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM('ru').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.d('ru').format(date),
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.E('ru').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
