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
      return _handleSignUpDioError(e);
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
      final response = await apiService.post('token/', {
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
      return _handleDioError(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Either<Failure, T> _handleSignUpDioError<T>(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 400) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final errorsMap = <String, List<String>>{};
        data.forEach((key, value) {
          if (value is List) {
            errorsMap[key] = List<String>.from(value);
          } else if (value is String) {
            errorsMap[key] = [value];
          }
        });
        return Left(
          ValidationFailure(
            errors: errorsMap,
            message: _formatErrorMessage(errorsMap),
          ),
        );
      }
      return Left(ServerFailure("Invalid registration data"));
    }

    if (statusCode == 500) {
      return Left(ServerFailure("Server error, try again later"));
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown) {
      return Left(NetworkFailure("Check your internet connection"));
    }

    return Left(ServerFailure("Unexpected error"));
  }

  Either<Failure, T> _handleDioError<T>(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 401) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final errorsMap = <String, List<String>>{};
        data.forEach((key, value) {
          if (value is List) {
            errorsMap[key] = List<String>.from(value);
          } else if (value is String) {
            errorsMap[key] = [value];
          }
        });
        return Left(
          ValidationFailure(
            errors: errorsMap,
            message: _formatErrorMessage(errorsMap),
          ),
        );
      }
      return Left(ServerFailure("Invalid credentials"));
    }

    if (statusCode == 500) {
      return Left(ServerFailure("Server error, try again later"));
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown) {
      return Left(NetworkFailure("Check your internet connection"));
    }

    return Left(ServerFailure("Unexpected error"));
  }

  String _formatErrorMessage(Map<String, List<String>> data) {
    final buffer = StringBuffer();
    data.forEach((key, value) {
      for (var msg in value) {
        buffer.writeln(msg);
      }
    });
    return buffer.toString().trim();
  }
}
