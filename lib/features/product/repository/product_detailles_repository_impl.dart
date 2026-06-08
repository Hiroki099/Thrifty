import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/repository/product_detailes_repository.dart';

class ProductDetaillesRepositoryImpl implements ProductDetailesRepository {
  @override
  Future<ItemModel> getProductDetailes(int productId) async {
    final ApiService apiService = ApiService();
    final data = await apiService.get(endpoint: 'items/retrieve/$productId/');
    return ItemModel.fromMap(data);
  }

  @override
  Future<List<ImageModel>> getProductImages(int productId) async {
    final ApiService apiService = ApiService();
    final data = await apiService.get(endpoint: 'items/$productId/get-images/');
    return (data as List).map((item) => ImageModel.fromMap(item)).toList();
  }
}
