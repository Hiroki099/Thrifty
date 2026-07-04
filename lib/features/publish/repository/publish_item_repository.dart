import 'dart:io';

import 'package:dealura/features/home/model/item_model.dart';

abstract class PublishItemRepository {
  Future<ItemModel> publishItem({
    required String name,
    required String description,
    double? price,
    required int categoryId,
    required List<File> images,
  });
  // Future<ItemModel> updateItem({
  //   required int itemId,
  //   required String name,
  //   required String description,
  //   double? price,
  //   required int categoryId,
  //   required List<File> images,

  Future<void> startAuction({
    required int itemId,
    required double startingPrice,
    required DateTime endTime,
  });
}
