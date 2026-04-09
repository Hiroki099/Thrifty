import 'package:dealura/features/auth/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController usernameController;
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
              hintText: 'Enter username',
              legend: 'Username',
              controller: usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username is required";
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            CustomTextField(
              obscureText: true,
              hintText: 'Enter your password',
              legend: 'Password',
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                return null;
              },
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
