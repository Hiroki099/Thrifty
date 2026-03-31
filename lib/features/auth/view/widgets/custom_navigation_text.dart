import 'package:flutter/material.dart';

class CustomNavigatonText extends StatelessWidget {
  const CustomNavigatonText({super.key, required this.direction});

  final String direction;

  @override
  Widget build(BuildContext context) {
    if (direction == "sign in") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              color: Color(0xFF888780),
              fontFamily: "IBM Plex Sans",
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              print("nav to sign in");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                color: Color(0xFFFA0707),
                fontFamily: "IBM Plex Sans",
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              color: Color(0xFF888780),
              fontFamily: "IBM Plex Sans",
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              print("nav to sign up");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                color: Color(0xFFFA0707),
                fontFamily: "IBM Plex Sans",
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }
  }
}
