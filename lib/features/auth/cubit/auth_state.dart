abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isSignUp; // لتحديد مصدر النجاح
  AuthSuccess({this.isSignUp = false});
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthValidationError extends AuthState {
  final Map<String, List<String>> errors;
  AuthValidationError(this.errors);
}