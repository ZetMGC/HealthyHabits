import 'package:flutter/material.dart';

class SuggestionsSection extends StatelessWidget {
  const SuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Предложения", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          children: [
            _suggestionCard("Продуктовый магазин", "Плов с Курицей", Colors.blue),
            const SizedBox(width: 12),
            _suggestionCard("Ресторан", "Паста Карбонара с грибами", Colors.orange.shade200),
          ],
        )
      ],
    );
  }

  Widget _suggestionCard(String type, String title, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
