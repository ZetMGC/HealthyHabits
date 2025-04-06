import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DropdownCardDatepicker extends StatefulWidget {
  final String initialTitle;
  final DateTime? initialDate;
  final bool initiallyExpanded;

  const DropdownCardDatepicker({
    super.key,
    this.initialTitle = "Название приема пищи",
    this.initialDate,
    this.initiallyExpanded = false,
  });

  @override
  State<DropdownCardDatepicker> createState() => _DropdownCardDatepickerState();
}

class _DropdownCardDatepickerState extends State<DropdownCardDatepicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  late TextEditingController _titleController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0; // Открываем сразу
    }

    _titleController = TextEditingController(text: widget.initialTitle);
    _selectedDate = widget.initialDate;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                _titleController.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _selectedDate != null
                    ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                    : "Выберите дату",
              ),
              trailing: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5)
                    .animate(_animationController),
                child: SvgPicture.asset(
                  'assets/icons/downarrow.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                      Colors.black54, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: Center(
            child: Container(
              width: 350,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _styledTextField("Название приема пищи", _titleController),
                  const SizedBox(height: 10),
                  _datePickerButton(),
                ],
              ),

            ),

          ),
        ),
      ],
    );
  }

  Widget _styledTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _datePickerButton() {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                  : "Выберите дату",
              style: const TextStyle(color: Colors.black87),
            ),
            SvgPicture.asset(
              'assets/icons/inactive_calendar.svg',
              width: 14,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}
