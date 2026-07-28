import 'dart:io';

import 'package:dealura/features/home/model/item_model.dart';

abstract class PublishItemRepository {
  Future<ItemModel> publishFixedPrice({
    required String name,
    required String description,
    required double? price,
    required int categoryId,
    required List<File> images,
  });

  Future<ItemModel> publishDonation({
    required String name,
    required String description,
    required int categoryId,
    required List<File> images,
  });

  Future<ItemModel> publishAuction({
    required String name,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required int categoryId,
    required List<File> images,
  });
  // Future<ItemModel> updateItem({
  //   required int itemId,
  //   required String name,
  //   required String description,
  //   required double? price,
  //   required int categoryId,
  //   required List<File> images,

  Future<Map<String, dynamic>> startAuction({
    required int itemId,
    required double startingPrice,
    required DateTime endTime,
  });
}
