import 'package:dealura/core/services/notification_services.dart';
import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/repository/auth_repository_impl.dart';
import 'package:dealura/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('MAIN: Firebase initialized');

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.instance.initialize();

  debugPrint('MAIN: NotificationService initialized');

  final chatToken = await getChatToken();

  final chatUserId = await getChatUserId();

  final chatApiKey = await getChatApiKey();

  if (chatToken != null && chatUserId != null && chatApiKey != null) {
    debugPrint(
      'MAIN: Initializing Stream Chat '
      'with user $chatUserId',
    );

    streamClient = StreamChatClient(chatApiKey, logLevel: Level.OFF);

    try {
      debugPrint('MAIN: Connecting user to Stream Chat...');

      await streamClient.connectUser(User(id: chatUserId), chatToken);

      debugPrint(
        'MAIN: STREAM USER CONNECTED: '
        '${streamClient.state.currentUser?.id}',
      );

      currentUserId = chatUserId;

      await NotificationService.instance.registerStreamDevice();

      NotificationService.instance.listenToStreamMessages();
    } catch (e, stackTrace) {
      debugPrint('MAIN: STREAM AUTO CONNECT FAILED: $e');

      debugPrint('MAIN: STACKTRACE: $stackTrace');

      currentUserId = null;
    }
  } else {
    debugPrint('MAIN: No Stream Chat tokens found.');

    streamClient = StreamChatClient('placeholder', logLevel: Level.OFF);

    currentUserId = null;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('MAIN: App lifecycle state changed to: $state');

    if (state == AppLifecycleState.resumed) {
      // App resumed from background - re-register push device
      debugPrint('MAIN: App resumed - re-initializing notifications');
      NotificationService.instance.onResume();
    } else if (state == AppLifecycleState.paused) {
      // App going to background - stop WebSocket listener to avoid duplicate notifications
      debugPrint('MAIN: App going to background - stopping WebSocket listener');
      NotificationService.instance.onPause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepositoryImpl(ApiService())),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dealura',
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFBF8F2)),
        routerConfig: AppRouter.router,

        builder: (context, child) {
          return StreamChat(
            client: streamClient,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
