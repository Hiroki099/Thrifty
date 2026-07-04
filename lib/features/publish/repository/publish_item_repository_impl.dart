import 'dart:io';

import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/publish/repository/publish_item_repository.dart';
import 'package:dio/dio.dart';

class PublishRepositoryImpl implements PublishItemRepository {
  final ApiService api = ApiService();

  @override
  Future<ItemModel> publishItem({
    required String name,
    required String description,
    double? price,
    required int categoryId,
    required List<File> images,
  }) async {
    final response = await api.post('items/create/', {
      "name": name,
      "description": description,
      "price": price,
      "category": categoryId,
    });

    final item = ItemModel.fromJson(response.data);

    if (images.isNotEmpty) {
      await _addItemPhotos(itemId: item.id!, images: images);
    }

    return item;
  }

  Future<void> _addItemPhotos({
    required int itemId,
    required List<File> images,
  }) async {
    final formData = FormData.fromMap({
      "images": images.map((image) {
        return MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split('/').last,
        );
      }).toList(),
    });

    await api.post('items/$itemId/images/', formData, isMultipart: true);
  }

  @override
  Future<void> startAuction({
    required int itemId,
    required double startingPrice,
    required DateTime endTime,
  }) async {
    await api.post('items/auctions/create/', {
      "item": itemId,
      "starting_price": startingPrice,
      "end_time": endTime.toIso8601String(),
    });
  }
}
