import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffE7A072),
      ),
      child: Text(
        "Filter",
        style: TextStyle(
          fontFamily: "IBM Plex Sans",
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
