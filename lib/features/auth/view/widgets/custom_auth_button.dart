import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342,
        height: 65,
        decoration: BoxDecoration(
          color: onTap == null
              ? Color(0xFFE7A072).withValues(alpha: 0.5)
              : Color(0xFFE7A072),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontFamily: "DM Serif Display", fontSize: 20),
          ),
        ),
      ),
    );
  }
}
