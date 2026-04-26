
import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MacBook Pro 14",
          style: const TextStyle(
            fontFamily: "IBM Plex Sans",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff000000),
          ),
        ),
    
        const SizedBox(height: 8),
    
        Text(
          "120,000 SYP",
          style: const TextStyle(
            fontFamily: "IBM Plex Sans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffE8A87C),
          ),
        ),
    
        const SizedBox(height: 6),
        Text(
          "Damascus • 1h • 23 views",
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xffB5B0A8),
            fontFamily: "IBM Plex Sans",
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}