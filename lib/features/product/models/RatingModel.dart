import 'package:dealura/features/auth/model/user_model.dart';

class RatingModel {
  final int? id;
  final UserModel? rater;
  final UserModel? seller;
  final String? itemName;
  final String? itemDetailUrl;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;

  RatingModel({
    this.id,
    this.rater,
    this.seller,
    this.itemName,
    this.itemDetailUrl,
    this.rating,
    this.comment,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rater: json['rater'] == null
          ? null
          : UserModel.fromPartialJson(json['rater']),
      seller: json['seller'] == null
          ? null
          : UserModel.fromPartialJson(json['seller']),
      itemName: json['item_name'],
      itemDetailUrl: json['item_detail_url'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
    );
  }
}