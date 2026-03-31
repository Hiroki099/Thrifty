import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
 const CustomAuthButton({super.key, required this.authText});

  final String authText;

  @override
  Widget build(BuildContext context) {
    if (authText == "Sign up")
     { return Container(
        width: 342,
        height: 65,
        decoration: BoxDecoration(
          color: Color(0xFFE7A072),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign up",
            style: TextStyle(fontFamily: "DM Serif Display", fontSize: 20),
          ),
        ),
      );}
    else {
      return Container(
        width: 342,
        height: 65,
        decoration: BoxDecoration(
          color: Color(0xFFE7A072),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in",
            style: TextStyle(fontFamily: "DM Serif Display", fontSize: 20),
          ),
        ),
      );
    }
  }
}
