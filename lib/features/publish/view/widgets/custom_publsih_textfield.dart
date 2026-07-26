import 'package:flutter/material.dart';

class CustomPublishTextField extends StatelessWidget {
  const CustomPublishTextField({
    super.key,
    required this.controller,
    required this.color,
  });

  final TextEditingController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        cursorColor: color,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffE5E2DC)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: color, width: 1.8),
          ),
        ),
      ),
    );
  }
}
