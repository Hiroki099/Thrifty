import 'package:dealura/features/auth/view/pages/sign_up_page.dart';
import 'package:dealura/features/onboarding/view/pages/get_started_page.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
static final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const GetStartedPage()),
    GoRoute(path: '/sign-up', builder: (context, state) => const SignUpPage()),
  ],
);}