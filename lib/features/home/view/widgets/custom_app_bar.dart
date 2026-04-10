import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 343,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  color: Color(0xff1A1A1A),
                  fontFamily: "DM Serif Display",
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Find something you love",
                style: TextStyle(
                  color: Color(0xff8A8580),
                  fontFamily: "IBM Plex Sans",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            height: 30,
            width: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xffE7A072), width: 1),
            ),
            child: Image.asset('assets/images/Bell_icon.png'),
          ),
        ],
      ),
    );
  }
}
