import 'package:dealura/core/errors/failures.dart';
import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/repository/auth_repository.dart';
import 'package:dealura/features/chat/repository/chat_repository_impl.dart';
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

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthFailure(failure.message));
        }
      },
      (token) async {
        print("ACCESS: ${token.access}");
        print("REFRESH: ${token.refresh}");

        await saveTokens(token.access!, token.refresh!);

        try {
          final chatRepo = ChatRepositoryImpl();
          final chat = await chatRepo.getChatToken();
          await saveChatTokens(chat);
          if (chat.apiKey == null ||
              chat.userId == null ||
              chat.token == null) {
            print("Warning: Failed to initialize chat, proceeding with login");
            emit(AuthSuccess());
            return;
          }
          print('AUTH CUBIT: Initializing Stream Chat client');
          print('  API Key: ${chat.apiKey}');
          print('  User ID: ${chat.userId}');
          print(
            '  Current streamClient user: ${streamClient.state.currentUser?.id}',
          );

          if (streamClient.state.currentUser != null) {
            print(
              'AUTH CUBIT: Found existing connected user: ${streamClient.state.currentUser?.id}',
            );
          }

          // Create new StreamChatClient instance
          streamClient = StreamChatClient(chat.apiKey!, logLevel: Level.OFF);

          try {
            print('AUTH CUBIT: Connecting user to Stream Chat...');
            await streamClient.connectUser(User(id: chat.userId!), chat.token!);

            print(
              'AUTH CUBIT: STREAM CONNECTED USER: '
              '${streamClient.state.currentUser?.id}',
            );

            currentUserId = chat.userId;
            print('AUTH CUBIT: currentUserId set to: $currentUserId');

            emit(AuthSuccess());
          } catch (e) {
            print("AUTH CUBIT ERROR: Failed to connect to stream chat: $e");
            currentUserId = null;
          }

          emit(AuthSuccess());
        } catch (e) {
          print("Warning: Chat setup failed: $e");
          emit(AuthSuccess());
        }
      },
    );
  }
}
