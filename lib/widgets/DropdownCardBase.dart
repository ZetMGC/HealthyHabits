import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DropdownCardBase extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget subtitle;
  final Widget expandedChild;
  final AnimationController animationController;
  final VoidCallback onTap;

  const DropdownCardBase({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.expandedChild,
    required this.animationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
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
            child: Padding(
              padding: const EdgeInsets.only(left:16, right: 25, top: 14, bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: icon),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        subtitle,
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(animation),
                    child: SvgPicture.asset(
                      'assets/icons/downarrow.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Colors.black54,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
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
              child: expandedChild,
            )
          ),
        )
      ],
    );
  }
}
