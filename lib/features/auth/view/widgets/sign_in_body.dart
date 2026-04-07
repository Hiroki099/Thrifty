import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/view/widgets/custom_auth_button.dart';
import 'package:dealura/features/auth/view/widgets/custom_navigation_text.dart';
import 'package:dealura/features/auth/view/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && !state.isSignUp) {
          context.go('/home');
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
        final isLoading = state is AuthLoading;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,

          /// 🔥 كل تصميمك كما هو
          child: SingleChildScrollView(
            child: Stack(
              children: [
                /// 🔵 الدائرة (كما كانت)
                Positioned(
                  top: -88,
                  left: -25,
                  child: Container(
                    width: 250,
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7A072).withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                /// 📦 المحتوى
                Padding(
                  padding: const EdgeInsets.only(top: 190, left: 25, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome back",
                        style: TextStyle(
                          fontFamily: "DM Serif Display",
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      SignInForm(
                        usernameController: usernameController,
                        passwordController: passwordController,
                      ),

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
                      CustomNavigatonText(direction: "sign up"),
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
