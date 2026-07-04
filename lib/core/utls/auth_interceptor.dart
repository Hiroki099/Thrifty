import 'package:dealura/core/utls/app_router.dart';
import 'package:dealura/core/utls/save_token.dart';
import 'package:dealura/variables.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.path.contains('token/refresh')) {
      await clearTokens();
      AppRouter.router.go('/');
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await getRefreshToken();

    if (refreshToken == null) {
      await clearTokens();
      AppRouter.router.go('/');
      return handler.next(err);
    }

    try {
      final refreshDio = Dio();

      final refreshResponse = await refreshDio.post(
        '$baseUrl/token/refresh/',
        data: {"refresh": refreshToken},
      );

      final newAccess = refreshResponse.data["access"];
      final newRefresh = refreshResponse.data["refresh"];

      await saveTokens(newAccess, newRefresh);

      final requestOptions = err.requestOptions;

      requestOptions.headers["Authorization"] = "Bearer $newAccess";

      final response = await dio.fetch(requestOptions);

      return handler.resolve(response);
    } catch (_) {
      await clearTokens();
      AppRouter.router.go('/');

      return handler.next(err);
    }
  }
}
