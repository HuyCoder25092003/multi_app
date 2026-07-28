import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.title,
    required this.labelText,
    required this.iconPath,
    this.suffixIcon,
    required this.enterErrol,
    required this.onChanged,
  });

  final String title;
  final String labelText;
  final String iconPath;
  final Widget? suffixIcon;
  final String enterErrol;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: GoogleFonts.nunitoSans(
              letterSpacing: 0.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        TextFormField(
          onChanged: onChanged,
          validator: (value) {
            if (value!.isEmpty)
              return "enter you email";
            else
              return null;
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            labelText: labelText,
            labelStyle: GoogleFonts.nunitoSans(
              letterSpacing: 0.1,
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(iconPath, width: 20, height: 20),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
