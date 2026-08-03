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
          if (chat.apiKey == null || chat.userId == null || chat.token == null) {
            // If chat initialization fails, still proceed with login
            print("Warning: Failed to initialize chat, proceeding with login");
            emit(AuthSuccess());
            return;
          }
          streamClient = StreamChatClient(chat.apiKey!, logLevel: Level.INFO);

          try {
            await streamClient.connectUser(User(id: chat.userId!), chat.token!);
            currentUserId = chat.userId!;
          } catch (e) {
            // If stream connection fails, still proceed with login
            print("Warning: Failed to connect to stream chat: $e");
            currentUserId = null;
          }

          emit(AuthSuccess());
        } catch (e) {
          // If chat setup fails entirely, still proceed with login
          print("Warning: Chat setup failed: $e");
          emit(AuthSuccess());
        }
      },
    );
  }
}
