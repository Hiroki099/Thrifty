import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
