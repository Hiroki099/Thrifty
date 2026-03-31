import 'package:dealura/features/auth/view/widgets/custiom_text_field.dart';
import 'package:dealura/features/auth/view/widgets/custom_auth_button.dart';
import 'package:dealura/features/auth/view/widgets/custom_navigation_text.dart';
import 'package:flutter/material.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -44,
              left: 217,
              child: Container(
                width: 250,
                height: 240,
                decoration: BoxDecoration(
                  color: Color(0xFFE7A072).withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create account",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: "DM Serif Display",
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "join a trusted community",
                    style: TextStyle(
                      color: Color(0xFF888780),
                      fontFamily: "IBM Plex Sans",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  CustomTextField(
                    hintText: 'Choose a username',
                    legend: 'Username',
                  ),
                  CustomTextField(
                    hintText: 'Enter your email',
                    legend: 'Email',
                  ),
                  CustomTextField(
                    hintText: 'Create a password',
                    legend: 'Password',
                  ),

                  CustomAuthButton(authText: "Sign up"),
                  SizedBox(height: 10),
                  CustomNavigatonText(direction: "sign in"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
