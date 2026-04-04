import 'package:dealura/features/auth/view/widgets/custiom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 91),

      child: Column(
        children: [
          CustomTextField(hintText: 'Choose a username', legend: 'Username'),
          SizedBox(height: 24),
          CustomTextField(hintText: 'Enter your email', legend: 'Email'),
          SizedBox(height: 24),
          CustomTextField(hintText: 'Create a password', legend: 'Password'),
        ],
      ),
    );
  }
}
