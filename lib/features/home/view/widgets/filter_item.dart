import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? const Color(0xffE7A072) : Colors.white,
          border: Border.all(color: const Color(0xffE7A072)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "IBM Plex Sans",
            fontSize: 13,
            color: isSelected ? Colors.white : const Color(0xffE7A072),
          ),
        ),
      ),
    );
  }
}
