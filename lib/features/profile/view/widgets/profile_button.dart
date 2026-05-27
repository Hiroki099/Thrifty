import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const ProfileButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xff888780), width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 33, bottom: 41, left: 16),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontFamily: "IBM Plex Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
