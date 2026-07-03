import 'package:dealura/core/utls/save_token.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl = 'https://thrifty-api-9bfr.onrender.com/api/';
  final Dio _dio = Dio();
  ApiService();
  //=========================================================================
  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await getAccessToken();

    final response = await _dio.get(
      '$_baseUrl$endpoint',
      queryParameters: queryParameters,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data;
  }

  //=========================================================================
  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await getAccessToken();
    final response = await _dio.post(
      '$_baseUrl$endpoint',
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    print("API RESPONSE: ${response.data}");
    return response;
  }

  //=========================================================================
  Future<dynamic> put(
    String endpoint,
    dynamic data, {
    bool isMultipart = false,
  }) async {
    final token = await getAccessToken();

    final response = await _dio.put(
      '$_baseUrl$endpoint',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          if (!isMultipart) 'Content-Type': 'application/json',
        },
      ),
    );

    return response.data;
  }
  //=========================================================================

  Future<dynamic> patch(
    String endpoint,
    dynamic data, {
    bool isMultipart = false,
  }) async {
    final token = await getAccessToken();

    final response = await _dio.patch(
      '$_baseUrl$endpoint',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          if (!isMultipart) 'Content-Type': 'application/json',
        },
      ),
    );

    return response.data;
  }

  //=========================================================================
  Future<dynamic> delete(String endpoint) async {
    final token = await getAccessToken();
    final response = await _dio.delete(
      '$_baseUrl$endpoint',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    print("API RESPONSE: ${response.data}");
    return response.data;
  }
}
