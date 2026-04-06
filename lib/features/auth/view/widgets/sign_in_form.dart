import 'package:dealura/features/auth/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 91),

      child: Column(
        children: [
          CustomTextField(
            hintText: 'Enter username',
            legend: 'Username',
            controller: usernameController,
          ),
          SizedBox(height: 24),
          CustomTextField(
            hintText: 'Enter your password',
            legend: 'Password',
            controller: passwordController,
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
