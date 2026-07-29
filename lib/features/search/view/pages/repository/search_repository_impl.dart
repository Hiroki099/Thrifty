import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/search/view/pages/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final data = await ApiService().get(endpoint: 'categories/list/');
      return (data as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<ItemModel>> getItemsList(
    String? search,
    int? categoryId,
    String? listringType,
    bool? isRecommended,
  ) async {
    try {
      final data = await ApiService().get(
        endpoint: 'items/list/',
        queryParameters: {
          'available': true,
          'category': ?categoryId,
          'type': ?listringType,
          'recommended': ?isRecommended,
          'search': ?search,
        },
      );

      return (data as List).map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
