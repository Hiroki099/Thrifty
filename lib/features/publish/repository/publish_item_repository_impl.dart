import 'dart:io';

import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/home/model/item_model.dart';
import 'package:dealura/features/publish/repository/publish_item_repository.dart';
import 'package:dio/dio.dart';

class PublishRepositoryImpl implements PublishItemRepository {
  final ApiService api = ApiService();

  @override
  Future<ItemModel> publishFixedPrice({
    required String name,
    required String description,
    required double? price,
    required int categoryId,
    required List<File> images,
  }) async {
    final response = await api.post('items/create/', {
      "name": name,
      "description": description,
      "price": price,
      "category": categoryId,
    });

    print("=================== ${response.data}");
    print("=================== ${response.data.runtimeType}");
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
    print("===================================== ${formData.fields}");
    print("===================================== ${formData.files}");
    final response = await api.post(
      'items/$itemId/images/',
      formData,
      isMultipart: true,
    );
    print("===================================== ${response.data}");
    print("===================================== ${response.data.runtimeType}");
  }

  @override
  Future<Map<String, dynamic>> startAuction({
    required int itemId,
    required double startingPrice,
    required DateTime endTime,
  }) async {
    final response = await api.post('items/auctions/create/', {
      "item": itemId,
      "start_price": startingPrice,
      "end_time": endTime.subtract(Duration(hours: 3)).toIso8601String(),
    });
    print("===================================== ${response.data}");
    print("===================================== ${response.data.runtimeType}");
    return response.data;
  }

  @override
  Future<ItemModel> publishDonation({
    required String name,
    required String description,
    required int categoryId,
    required List<File> images,
  }) async {
    final response = await api.post('items/create/', {
      "name": name,
      "description": description,
      "listing_type": "donation",
      "category": categoryId,
    });

    print("=================== ${response.data}");
    print("=================== ${response.data.runtimeType}");
    final item = ItemModel.fromJson(response.data);

    if (images.isNotEmpty) {
      await _addItemPhotos(itemId: item.id!, images: images);
    }

    return item;
  }

  @override
  Future<ItemModel> publishAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required int categoryId,
    required List<File> images,
  }) async {
    final response = await api.post('items/create/', {
      "name": name,
      "description": description,
      "listing_type": "auction",
      "category": categoryId,
    });

    print("=================== ${response.data}");
    print("=================== ${response.data.runtimeType}");
    final item = ItemModel.fromJson(response.data);

    if (images.isNotEmpty) {
      await _addItemPhotos(itemId: item.id!, images: images);
    }

    await startAuction(
      itemId: item.id!,
      startingPrice: startingPrice,
      endTime: endTime,
    );

    return item;
  }
}
