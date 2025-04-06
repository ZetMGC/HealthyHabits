import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DropdownCardBase.dart';

class DropdownCardRating extends StatefulWidget {
  const DropdownCardRating({super.key});

  @override
  State<DropdownCardRating> createState() => _DropdownCardRatingState();
}

class _DropdownCardRatingState extends State<DropdownCardRating>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadRating();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Future<void> _loadRating() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentRating = prefs.getInt('user_rating') ?? 0;
    });
  }

  Future<void> _saveRating(int rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_rating', rating);
  }

  Widget _buildStarRating() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          bool isActive = index < _currentRating;
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentRating = index + 1;
                _saveRating(_currentRating);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: isActive ? 1.2 : 1.0),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      isActive ? Icons.star : Icons.star_border,
                      color: Colors.deepOrange,
                      size: 22,
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return DropdownCardBase(
      icon: SvgPicture.asset(
        'assets/icons/inactive_chat.svg',
        width: 14,
        height: 14,
      ),
      title: "Отметить ощущения",
      subtitle: _buildStarRating(),
      expandedChild: Column(
        children: [
          _styledTextField("Комментарий"),
        ],
      ),
      animationController: _animationController,
      onTap: _toggleExpansion,
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _styledTextField(String hint) {
    return TextField(
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

}
