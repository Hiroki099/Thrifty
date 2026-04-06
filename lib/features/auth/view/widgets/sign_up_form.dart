import 'package:dealura/features/auth/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 91),
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Choose a username',
            legend: 'Username',
            controller: usernameController,
          ),
          SizedBox(height: 24),
          CustomTextField(
            hintText: 'Enter your email',
            legend: 'Email',
            controller: emailController,
          ),
          SizedBox(height: 24),
          CustomTextField(
            hintText: 'Create a password',
            legend: 'Password',
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}
