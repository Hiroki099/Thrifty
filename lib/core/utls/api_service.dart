import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'https://thrifty-api-9bfr.onrender.com/api';
  final Dio dio;
  ApiService(this.dio);
  Future<Map<String, dynamic>> get({required String endpoint}) async {
    var response = await dio.get('$baseUrl/$endpoint');
    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    Future<Response> response = dio.post('$baseUrl/$endpoint', data: body);
    return response;
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    // Implement PUT request logic here
  }

  Future<dynamic> delete(String endpoint) async {
    // Implement DELETE request logic here
  }
}
