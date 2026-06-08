class TransactionModel {
  int? id;
  String? amount;
  String? balanceAfter;
  String? kind;
  String? referenceType;
  String? referenceId;
  String? description;
  DateTime? createdAt;

  TransactionModel({
    this.id,
    this.amount,
    this.balanceAfter,
    this.kind,
    this.referenceType,
    this.referenceId,
    this.description,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int?,
      amount: json['amount'] as String?,
      balanceAfter: json['balance_after'] as String?,
      kind: json['kind'] as String?,
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'balance_after': balanceAfter,
    'kind': kind,
    'reference_type': referenceType,
    'reference_id': referenceId,
    'description': description,
    'created_at': createdAt?.toIso8601String(),
  };
}
