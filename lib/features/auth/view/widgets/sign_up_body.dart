import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/view/widgets/custom_auth_button.dart';
import 'package:dealura/features/auth/view/widgets/custom_navigation_text.dart';
import 'package:dealura/features/auth/view/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home');
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthValidationError) {
          final errorMessage = state.errors.entries
              .map((e) => "${e.key}: ${e.value.join(', ')}")
              .join("\n");

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: -44,
                  left: 217,
                  child: Container(
                    width: 250,
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7A072).withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 190, left: 25, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create account",
                        style: TextStyle(
                          fontFamily: "DM Serif Display",
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: const Text(
                          "join a trusted community",
                          style: TextStyle(
                            color: Color(0xFF888780),
                            fontFamily: "IBM Plex Sans",
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SignUpForm(
                        usernameController: usernameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey,
                      ),
                      CustomAuthButton(
                        text: "Sign up",
                        onTap: isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                    username: usernameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 9),
                      CustomNavigatonText(direction: "sign in"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
