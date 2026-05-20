import 'package:dealura/features/auth/view/pages/sign_in_page.dart';
import 'package:dealura/features/auth/view/pages/sign_up_page.dart';
import 'package:dealura/features/navigation/view/pages/main_page.dart';
import 'package:dealura/features/onboarding/view/pages/get_started_page.dart';
import 'package:dealura/features/product/view/pages/product_details_page.dart';
import 'package:dealura/features/publish/view/pages/publish_page.dart';
import 'package:dealura/features/splash/view/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const GetStartedPage()),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const MainPage()),
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/product_details',
        builder: (context, state) {
          final type = state.extra as String;

          return ProductDetailsPage(type: type);
        },
      ),
      GoRoute(
        path: '/publish',
        builder: (context, state) => const PublishPage(),
      ),
    ],
  );
}
