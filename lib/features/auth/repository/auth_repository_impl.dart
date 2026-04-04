import 'package:dartz/dartz.dart';
import 'package:dealura/core/errors/failures.dart';
import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/auth/model/token_model.dart';
import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/auth/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  AuthRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await apiService.post('users/register/', {
        'email': email,
        'password': password,
        'username': username,
      });

      final user = UserModel.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      //  Validation errors (400)
      if (e.response?.statusCode == 400) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          return Left(
            ValidationFailure(
              errors: data.map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
              message: _formatErrorMessage(data),
            ),
          );
        }
      }

      //  Server error (500)
      if (e.response?.statusCode == 500) {
        return Left(ServerFailure("Server error, try again later"));
      }

      //  Network error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(NetworkFailure("Check your internet connection"));
      }

      return Left(ServerFailure("Unexpected error"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TokenModel>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiService.post('users/login/', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = TokenModel.fromJson(response.data);
        return Right(token);
      } else {
        return Left(ServerFailure("Login failed"));
      }
    } on DioException catch (e) {
      //  1. Validation error (مثلاً wrong credentials)
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          return Left(
            ValidationFailure(
              errors: data.map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
              message: _formatErrorMessage(data),
            ),
          );
        }

        return Left(ServerFailure("Invalid credentials"));
      }

      //  2. Server error
      if (e.response?.statusCode == 500) {
        return Left(ServerFailure("Server error, try again later"));
      }

      //  3. Network error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(NetworkFailure("Check your internet connection"));
      }

      return Left(ServerFailure("Unexpected error"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _formatErrorMessage(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    data.forEach((key, value) {
      if (value is List) {
        for (var msg in value) {
          buffer.writeln(msg);
        }
      }
    });

    return buffer.toString().trim();
  }
}
