import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  dynamic img;
  final String name;
  final Color backgroundColor;
  final Color? textColor;

  ImagePicker({
    super.key,
    required this.img,
    required this.name,
    required this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: img != null
            ? Image.memory(img)
            : Text(name, style: TextStyle(color: textColor)),
      ),
    );
  }
}
