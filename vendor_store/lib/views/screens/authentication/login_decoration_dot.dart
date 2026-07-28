import 'package:flutter/material.dart';

class LoginDecorationDot extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final double opacity;
  final double circular;

  const LoginDecorationDot({
    super.key,
    required this.left,
    required this.top,
    required this.size,
    this.opacity = 0.3,
    required this.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(circular),
          ),
        ),
      ),
    );
  }
}
