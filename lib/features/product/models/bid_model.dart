import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';

class BidModel {
  final int? id;
  final int? auction;
  final int? bidder;
  final UserModel? bidderUser;
  final ItemModel? item;
  final String? bidAmount;
  final DateTime? bidDate;

  const BidModel({
    this.id,
    this.auction,
    this.bidder,
    this.bidderUser,
    this.item,
    this.bidAmount,
    this.bidDate,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    final bidderData = json['bidder'];

    int? bidderId;
    UserModel? bidderUser;

    if (bidderData is int) {
      bidderId = bidderData;
    } else if (bidderData is Map<String, dynamic>) {
      bidderUser = UserModel.fromPartialJson(bidderData);
      bidderId = bidderUser.id;
    }

    return BidModel(
      id: json['id'] as int?,
      auction: json['auction'] as int?,
      bidder: bidderId,
      bidderUser: bidderUser,

      item: json['item'] is Map<String, dynamic>
          ? ItemModel.fromJson(json['item'] as Map<String, dynamic>)
          : null,

      bidAmount: json['bid_amount'] as String?,

      bidDate: json['bid_date'] == null
          ? null
          : DateTime.parse(json['bid_date'] as String),
    );
  }


}