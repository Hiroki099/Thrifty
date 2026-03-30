import 'package:dealura/core/utls/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFBF8F2)),
      debugShowCheckedModeBanner: false,
    );
  }
}
