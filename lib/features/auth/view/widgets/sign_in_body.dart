import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/view/widgets/custom_auth_button.dart';
import 'package:dealura/features/auth/view/widgets/custom_navigation_text.dart';
import 'package:dealura/features/auth/view/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 190, left: 25, right: 19),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess && !state.isSignUp) {
              context.go('/home'); // 🔥 نجاح تسجيل الدخول
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is AuthValidationError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errors.toString())));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back",
                  style: TextStyle(
                    fontFamily: "DM Serif Display",
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Sign in to continue"),

                /// 🔥 الفورم (لم نحذفه)
                SignInForm(
                  usernameController: usernameController,
                  passwordController: passwordController,
                ),

                if (state is AuthLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomAuthButton(
                    text: "Sign in",
                    onTap: () {
                      context.read<AuthCubit>().signIn(
                        username: usernameController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    },
                  ),

                const SizedBox(height: 9),

                /// 🔥 التنقل إلى signup
                CustomNavigatonText(direction: "sign up"),
              ],
            );
          },
        ),
      ),
    );
  }
}
