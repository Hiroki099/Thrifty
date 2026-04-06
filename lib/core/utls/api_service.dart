import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl = 'https://thrifty-api-9bfr.onrender.com/api/';
  final Dio _dio;
  ApiService(this._dio);
  Future<Map<String, dynamic>> get({required String endpoint}) async {
    var response = await _dio.get('$_baseUrl/$endpoint');
    return response.data as Map<String, dynamic>;
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _dio.post(
      '$_baseUrl$endpoint', // ⚠️ انتبه هنا
      data: body,
    );

    print("API RESPONSE: ${response.data}"); // 🔥 للتأكد

    return response;
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    // Implement PUT request logic here
  }

  Future<dynamic> delete(String endpoint) async {
    // Implement DELETE request logic here
  }
}
