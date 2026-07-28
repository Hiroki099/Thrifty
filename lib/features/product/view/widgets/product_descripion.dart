import 'package:flutter/material.dart';

class ProductDescripion extends StatelessWidget {
  const ProductDescripion({super.key, required this.description});

  final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "DESCRIPTION",
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1,
            color: Color(0xff8A8580),
            fontFamily: "IBM Plex Sans",
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 11),
        Text(
          description,
          style: const TextStyle(
            fontSize: 13,
            height: 1.85,
            fontFamily: "IBM Plex Sans",
            color: Color(0xff4A4744),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
