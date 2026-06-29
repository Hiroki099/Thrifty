class WalletModel {
  int? id;
  String? balance;
  DateTime? updatedAt;

  WalletModel({this.id, this.balance, this.updatedAt});

  factory WalletModel.fromJson(Map<String, dynamic> data) => WalletModel(
    id: data['id'] as int?,
    balance: data['balance'] as String?,
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'balance': balance,
    'updated_at': updatedAt?.toIso8601String(),
  };
}
