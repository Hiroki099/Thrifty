import 'package:dealura/core/errors/failures.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/features/auth/cubit/auth_state.dart';
import 'package:dealura/features/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial());

  /// Sign Up مع تسجيل دخول تلقائي
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

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthFailure(failure.message));
        }
      },
      (_) async {
        // نجح التسجيل → نرسل حالة نجاح SignUp
        emit(AuthSuccess(isSignUp: true));

        // تسجيل دخول تلقائي بعد التسجيل
        await signIn(username: username, password: password);
      },
    );
  }

  /// Sign In
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
        // حفظ التوكنات بشكل آمن
        await saveTokens(token.access!, token.refresh!);

        emit(AuthSuccess());
      },
    );
  }
}
