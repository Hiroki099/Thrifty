import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/home/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiService apiService = ApiService();

  @override
  Future<List<ItemModel>> getItemsList(
    int? categoryId,
    String? listringType,
    bool? isRecommended,
  ) async {
    try {
      final data = await apiService.get(
        endpoint: 'items/list/',
        queryParameters: {
          'available': true,
          'category': ?categoryId,
          'type': ?listringType,
          'recommended': ?isRecommended,
        },
      );

      return (data as List).map((item) => ItemModel.fromMap(item)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final data = await apiService.get(endpoint: 'categories/list/');
      return (data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
