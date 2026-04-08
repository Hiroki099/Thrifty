import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.legend,
    required this.controller,
    this.validator,
    this.obscureText = false,
  });
  final String hintText, legend;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          legend,
          style: TextStyle(
            color: Color(0xFF4A4843),
            fontFamily: "IBM Plex Sans",
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),

          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            style: TextStyle(color: Color(0xFFB0AFA8)),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(14),
              filled: true,
              fillColor: Color(0xFFFFFFFF),

              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFFB0AFA8),
                fontFamily: "IBM Plex Sans",
                fontSize: 20,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFD3D1C7), width: 1.5),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFD3D1C7), width: 1.5),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFD3D1C7), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
