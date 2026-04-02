import 'package:dealura/features/auth/view/widgets/custom_auth_button.dart';
import 'package:dealura/features/auth/view/widgets/custom_navigation_text.dart';
import 'package:dealura/features/auth/view/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInBody extends StatelessWidget {
  const SignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: -88,
            left: -25,
            child: Container(
              width: 240,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFFE7A072).withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 190, left: 25, right: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back!",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: "DM Serif Display",
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Text(
                    "Sign to your account",
                    style: TextStyle(
                      color: Color(0xFF888780),
                      fontFamily: "IBM Plex Sans",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SignInForm(),

                CustomAuthButton(text: "Sign in"),
                SizedBox(height: 9),
                CustomNavigatonText(direction: "sign up"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
