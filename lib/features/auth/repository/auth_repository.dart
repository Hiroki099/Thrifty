import 'package:dealura/features/auth/model/token_model.dart';
import 'package:dealura/features/auth/model/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<TokenModel> signIn({
    required String username,
    required String password,
  });
}
