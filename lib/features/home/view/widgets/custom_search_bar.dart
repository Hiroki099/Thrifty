import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffD3D1C7), width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      height: 45,
      width: 361,
      child: Row(
        children: [
          Icon(Icons.search, color: Color(0xffDFDBD5)),
          Text(
            "Search here",
            style: TextStyle(
              fontFamily: "IBM Plex Sans",
              fontSize: 17,
              color: Color(0xffB0AFA8),
            ),
          ),
        ],
      ),
    );
  }
}
