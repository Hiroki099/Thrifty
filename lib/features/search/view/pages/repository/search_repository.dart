import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';

abstract class SearchRepository {
  Future<List<ItemModel?>> getItemsList(
    String? search,
    int? categoryId,
    String? listringType,
    bool? isRecommended,
  );
  Future<List<CategoryModel?>> getCategoriesList();
}
