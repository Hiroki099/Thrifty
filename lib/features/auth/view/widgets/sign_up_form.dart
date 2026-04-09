import 'package:dealura/features/auth/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 91),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Choose a username',
              legend: 'Username',
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username is required";
                }
                if (value.length < 3) {
                  return "Username too short";
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            CustomTextField(
              hintText: 'Enter your email',
              legend: 'Email',
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return "Please enter a valid email address";
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            CustomTextField(
              obscureText: true,
              hintText: 'Create a password',
              legend: 'Password',
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                if (value.length < 2) {
                  return "Password too short";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
