import 'package:dealura/features/home/model/category_model.dart';
import 'package:dealura/features/home/model/item_model.dart';

abstract class HomeRepository {
  Future<List<ItemModel?>> getItemsList();
  Future<List<CategoryModel?>> getCategoriesList();
  Future<List<String>> getItemsImages();
  Future<ItemModel?> getItemDetail(int id);
  Future<List<ItemModel?>> getItemsByCategory(int categoryId);
  
}
