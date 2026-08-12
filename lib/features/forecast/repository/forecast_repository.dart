import 'package:dealura/features/forecast/model/currency_model.dart';
import 'package:dio/dio.dart';

class ForecastRepository {
  final Dio _api = Dio();

  Future<List<CurrencyModel>> getForecast() async {
    final response = await _api.get(
      'https://api.frankfurter.dev/v2/rates?base=SYP&quotes=USD,EUR,AED,TRY,EGP,SAR',
    );

    final data = response.data;

    if (data is! List) {
      throw Exception('Invalid currency response');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(CurrencyModel.fromJson)
        .toList();
  }
}
