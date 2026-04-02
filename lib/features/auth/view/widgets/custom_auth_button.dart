import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xFFE7A072),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontFamily: "DM Serif Display", fontSize: 20),
        ),
      ),
    );
  }
}
