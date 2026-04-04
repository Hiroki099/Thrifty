import 'package:dartz/dartz.dart';
import 'package:dealura/core/errors/failures.dart';
import 'package:dealura/features/auth/model/token_model.dart';
import 'package:dealura/features/auth/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<Either<Failure, TokenModel>> signIn({
    required String username,
    required String password,
  });
}
