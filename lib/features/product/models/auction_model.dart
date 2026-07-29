class AuctionModel {
  int? id;
  int? item;
  String? status;
  String? startPrice;
  String? currentPrice;
  DateTime? startTime;
  DateTime? endTime;
  int? winner;

  AuctionModel({
    this.id,
    this.item,
    this.status,
    this.startPrice,
    this.currentPrice,
    this.startTime,
    this.endTime,
    this.winner,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) => AuctionModel(
    id: json['id'] as int?,
    item: json['item'] as int?,
    status: json['status'] as String?,
    startPrice: json['start_price'] as String?,
    currentPrice: json['current_price'] as String?,
    startTime: json['start_time'] == null
        ? null
        : DateTime.parse(json['start_time'] as String),
    endTime: json['end_time'] == null
        ? null
        : DateTime.parse(json['end_time'] as String),
    winner: json['winner'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item,
    'status': status,
    'start_price': startPrice,
    'current_price': currentPrice,
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'winner': winner,
  };
}
