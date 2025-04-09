import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final Function(String) onChanged;

  const FilterButtons({
    super.key,
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: filters.map((filter) {
        final isSelected = selected == filter;
        return ChoiceChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (_) => onChanged(filter),
          selectedColor: Colors.red,
        );
      }).toList(),
    );
  }
}
