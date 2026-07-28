import 'package:flutter/material.dart';

class HeaderButton extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;
  final String img;

  const HeaderButton({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(img)),
            ),
          ),
        ),
      ),
    );
  }
}
