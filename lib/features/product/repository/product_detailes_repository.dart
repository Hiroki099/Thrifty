import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/auction_model.dart';
import 'package:dealura/features/product/models/bid_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/models/request_model.dart';

abstract class ProductDetailesRepository {
  Future<ItemModel> getProductDetailes(int productId);
  Future<List<ImageModel>> getProductImages(int productId);
  Future<AuctionModel> getAuctionDetails(int productId);
  Future<List<RatingModel>> getOwnerRating(int ownerId);
  Future<RequestModel> requestForDonation(int productId);
  Future<void> cancelRequest(int requestId);
  Future<Map<String, dynamic>> purchaseItem(int productId);
  Future<void> updateProductDetails(
    int productId,
    Map<String, dynamic> updatedData,
  );
  Future<List<RequestModel>> getRequests(String typeFillter);
  Future<void> deleteProduct(int productId);
  Future<BidModel> createBid(int productId, int amount);
}
