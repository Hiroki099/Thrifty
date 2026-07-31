class BidModel {
  int? id;
  int? auction;
  int? bidder;
  String? bidAmount;
  DateTime? bidDate;

  BidModel({this.id, this.auction, this.bidder, this.bidAmount, this.bidDate});

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
    id: json['id'] as int?,
    auction: json['auction'] as int?,
    bidder: json['bidder'] as int?,
    bidAmount: json['bid_amount'] as String?,
    bidDate: json['bid_date'] == null
        ? null
        : DateTime.parse(json['bid_date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'auction': auction,
    'bidder': bidder,
    'bid_amount': bidAmount,
    'bid_date': bidDate?.toIso8601String(),
  };
}
