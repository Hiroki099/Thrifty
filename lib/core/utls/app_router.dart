import 'package:dealura/features/auth/view/pages/sign_in_page.dart';
import 'package:dealura/features/auth/view/pages/sign_up_page.dart';
import 'package:dealura/features/navigation/view/pages/main_page.dart';
import 'package:dealura/features/notification/view/pages/notification_page.dart';
import 'package:dealura/features/onboarding/view/pages/get_started_page.dart';
import 'package:dealura/features/product/view/pages/product_details_page.dart';
import 'package:dealura/features/profile/view/pages/Ratings_page.dart';
import 'package:dealura/features/profile/view/pages/account_setting_page.dart';
import 'package:dealura/features/profile/view/pages/balance_page.dart';
import 'package:dealura/features/profile/view/pages/edit_profile_page.dart';
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
          final id = state.extra as int?;

          return ProductDetailsPage(id: id);
        },
      ),
      GoRoute(
        path: '/publish',
        builder: (context, state) => const PublishPage(),
      ),

      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/account_setting',
        builder: (context, state) => const AccountSettingPage(),
      ),
      GoRoute(
        path: '/balance',
        builder: (context, state) => const BalancePage(),
      ),
      GoRoute(
        path: '/ratings',
        builder: (context, state) => const RatingsPage(),
      ),
    ],
  );
}
