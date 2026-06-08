import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';

abstract class ProductDetailesRepository {
  Future<ItemModel> getProductDetailes(int productId);
  Future<List<ImageModel>> getProductImages(int productId);
}
