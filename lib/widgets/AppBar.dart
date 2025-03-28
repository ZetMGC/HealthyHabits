import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.backgroundColor = Colors.white,
    this.trailingIcon,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (trailingIcon != null)
          IconButton(
            icon: Icon(trailingIcon, color: Colors.black),
            onPressed: onTrailingPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
