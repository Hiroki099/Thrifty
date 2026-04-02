import 'package:dealura/features/auth/view/widgets/custiom_text_field.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 91),

      child: Column(
        children: [
          CustomTextField(hintText: 'Enter username', legend: 'Username'),
          SizedBox(height: 24),
          CustomTextField(hintText: 'Enter your password', legend: 'Password'),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
