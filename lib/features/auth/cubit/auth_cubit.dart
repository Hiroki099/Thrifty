import 'package:dealura/core/errors/failures.dart';
import 'package:dealura/core/services/notification_services.dart';
import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/repository/auth_repository.dart';
import 'package:dealura/features/chat/repository/chat_repository_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial());

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await repo.signUp(
      username: username,
      email: email,
      password: password,
    );

    await result.fold(
      (failure) async {
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthFailure(failure.message));
        }
      },
      (_) async {
        await signIn(username: username, password: password);
      },
    );
  }

  
  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await repo.signIn(username: username, password: password);

    await result.fold(
      (failure) async {
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthFailure(failure.message));
        }
      },
      (token) async {
        try {
          debugPrint('========================================');
          debugPrint('AUTH: LOGIN SUCCESS');
          debugPrint('========================================');

          debugPrint('ACCESS: ${token.access}');
          debugPrint('REFRESH: ${token.refresh}');

          await saveTokens(token.access!, token.refresh!);

          debugPrint('AUTH: Auth tokens saved');

          final chatRepo = ChatRepositoryImpl();

          debugPrint('AUTH: Getting Stream Chat credentials...');

          final chat = await chatRepo.getChatToken();

          debugPrint('AUTH: Stream credentials received');
          debugPrint('AUTH: API KEY = ${chat.apiKey}');
          debugPrint('AUTH: USER ID = ${chat.userId}');
          debugPrint('AUTH: TOKEN EXISTS = ${chat.token != null}');

      
          if (chat.apiKey == null ||
              chat.userId == null ||
              chat.token == null) {
            debugPrint('AUTH: Stream credentials are incomplete.');
            emit(AuthSuccess());
            return;
          }

       
          await saveChatTokens(chat);

          debugPrint('AUTH: Stream credentials saved');

          try {
            if (streamClient.state.currentUser != null) {
              debugPrint(
                'AUTH: Disconnecting previous Stream user '
                '${streamClient.state.currentUser?.id}',
              );

              await streamClient.disconnectUser();
            }
          } catch (e) {
            debugPrint('AUTH: Previous Stream disconnect error: $e');
          }


          streamClient = StreamChatClient(chat.apiKey!, logLevel: Level.OFF);

          debugPrint('AUTH: Stream client created');


          debugPrint(
            'AUTH: Connecting Stream user '
            '${chat.userId}...',
          );

          await streamClient.connectUser(User(id: chat.userId!), chat.token!);


          final connectedUser = streamClient.state.currentUser;

          if (connectedUser == null) {
            debugPrint(
              'AUTH: Stream connection returned '
              'but currentUser is null.',
            );

            emit(AuthSuccess());
            return;
          }

          debugPrint('========================================');

          debugPrint('AUTH: STREAM CONNECTED');

          debugPrint('AUTH: USER = ${connectedUser.id}');

          debugPrint('========================================');

          currentUserId = chat.userId!;


          debugPrint('AUTH: Registering FCM device with Stream...');

          await NotificationService.instance.registerStreamDevice();

          debugPrint('AUTH: FCM device registration completed');


          NotificationService.instance.listenToStreamMessages();

          debugPrint('AUTH: Stream foreground listener started');


          emit(AuthSuccess());

          debugPrint('========================================');

          debugPrint('AUTH: COMPLETE LOGIN FLOW FINISHED');

          debugPrint('========================================');
        } catch (e, stackTrace) {
          debugPrint('========================================');
          debugPrint('AUTH: STREAM SETUP FAILED');

          debugPrint('ERROR: $e');

          debugPrint('STACKTRACE:');

          debugPrint('$stackTrace');

          debugPrint('========================================');

          currentUserId = null;

          emit(AuthSuccess());
        }
      },
    );
  }
}
