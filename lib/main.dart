import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/cubit/auth_cubit.dart';
import 'package:dealura/features/auth/repository/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final chatToken = await getChatToken();
  final chatUserId = await getChatUserId();
  final chatApiKey = await getChatApiKey();

  if (chatToken != null && chatUserId != null && chatApiKey != null) {
    print('MAIN: Initializing Stream Chat with user $chatUserId');

    if (streamClient.state.currentUser != null) {
      print(
        'MAIN: Found existing connected user: ${streamClient.state.currentUser?.id}',
      );
    }

    // Create new StreamChatClient instance
    streamClient = StreamChatClient(chatApiKey, logLevel: Level.OFF);

    try {
      await streamClient.connectUser(User(id: chatUserId), chatToken);

      print(
        'MAIN: STREAM USER CONNECTED: '
        '${streamClient.state.currentUser?.id}',
      );

      currentUserId = chatUserId;
      print('MAIN: currentUserId set to: $currentUserId');
    } catch (e) {
      print('MAIN: STREAM AUTO CONNECT FAILED: $e');

      await clearTokens();

      streamClient = StreamChatClient(chatApiKey, logLevel: Level.OFF);

      currentUserId = null;
    }
  } else {
    print('MAIN: No Stream Chat tokens found, using placeholder');
    streamClient = StreamChatClient('placeholder', logLevel: Level.OFF);

    currentUserId = null;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
