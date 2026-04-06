import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/repository/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepositoryImpl(ApiService(Dio()))),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dealura',
        theme: ThemeData(scaffoldBackgroundColor: Color(0xFFFBF8F2)),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
