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

ValueNotifier<StreamChatClient> streamClientNotifier = ValueNotifier(
  streamClient,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.instance.initialize();

  final chatToken = await getChatToken();
  final chatUserId = await getChatUserId();
  final chatApiKey = await getChatApiKey();

  if (chatToken != null && chatUserId != null && chatApiKey != null) {
    streamClient = StreamChatClient(chatApiKey, logLevel: Level.OFF);
    streamClientNotifier.value = streamClient;

    try {
      await streamClient.connectUser(User(id: chatUserId), chatToken);
      currentUserId = chatUserId;
      await NotificationService.instance.registerStreamDevice();
      NotificationService.instance.listenToStreamMessages();
    } catch (e) {
      debugPrint('MAIN: STREAM AUTO CONNECT FAILED: $e');
      currentUserId = null;
    }
  } else {
    streamClient = StreamChatClient('placeholder', logLevel: Level.OFF);
    streamClientNotifier.value = streamClient;
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
    if (state == AppLifecycleState.resumed) {
      NotificationService.instance.onResume();
    } else if (state == AppLifecycleState.paused) {
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
      child: ValueListenableBuilder<StreamChatClient>(
        valueListenable: streamClientNotifier,
        builder: (context, currentClient, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Dealura',
            theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFBF8F2)),
            routerConfig: AppRouter.router,
            builder: (context, routerChild) {
              return StreamChat(
                client: currentClient,
                child: routerChild ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
