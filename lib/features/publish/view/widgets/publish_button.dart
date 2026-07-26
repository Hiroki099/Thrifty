import 'package:flutter/material.dart';

class PublishButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  const PublishButton({
    super.key,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Publish listing",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "IBM Plex Sans",
          ),
        ),
      ),
    );
  }
}
