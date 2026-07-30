import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/product/models/RatingModel.dart';
import 'package:dealura/features/product/models/auction_model.dart';
import 'package:dealura/features/product/models/image_model/image_model.dart';
import 'package:dealura/features/product/models/request_model.dart';
import 'package:dealura/features/product/repository/product_detailes_repository.dart';

class ProductDetaillesRepositoryImpl implements ProductDetailesRepository {
  @override
  Future<ItemModel> getProductDetailes(int productId) async {
    final ApiService apiService = ApiService();
    final data = await apiService.get(endpoint: 'items/retrieve/$productId/');
    return ItemModel.fromJson(data);
  }

  @override
  Future<List<ImageModel>> getProductImages(int productId) async {
    final ApiService apiService = ApiService();
    final data = await apiService.get(endpoint: 'items/$productId/get-images/');
    return (data as List).map((item) => ImageModel.fromMap(item)).toList();
  }

  @override
  Future<List<RatingModel>> getOwnerRating(int ownerId) async {
    final api = ApiService();

    final data = await api.get(endpoint: 'ratings/seller/$ownerId/ratings/');

    return (data as List).map((e) => RatingModel.fromJson(e)).toList();
  }

  @override
  Future<AuctionModel> getAuctionDetails(int productId) async {
    final api = ApiService();

    return await api.get(endpoint: 'items/$productId/auction/').then((data) {
      return AuctionModel.fromJson(data);
    });
  }

  @override
  Future<void> cancelRequest(int requestId) async {
    final api = ApiService();
    await api.delete('items/requests/$requestId/delete/');
  }

  @override
  Future<RequestModel> requestForDonation(int productId) async {
    final api = ApiService();
    final response = await api.post('items/request/create/', {
      "item": productId,
    });
    return RequestModel.fromJson(response.data);
  }

  @override
  Future<Map<String, dynamic>> purchaseItem(int productId) async {
    final api = ApiService();
    final response = await api.post('items/$productId/purchase/', {});
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> updateProductDetails(
    int productId,
    Map<String, dynamic> updatedData,
  ) async {
    final api = ApiService();
    return await api.patch('items/$productId/update/', updatedData);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    final api = ApiService();
    return await api.delete('items/$productId/delete/');
  }

  @override
  Future<Map<String, dynamic>> createBid(int auctionId, int amount) async {
    final api = ApiService();
    final response = await api.post('items/bids/create/', {
      'bid_amount': amount,
      'auction': auctionId,
    });
    return response.data as Map<String, dynamic>;
  }
}
