import 'package:dealura/features/auth/model/user_model.dart';

class RequestModel {
  int? id;
  int? item;
  UserModel? requester;
  String? status;
  DateTime? createdAt;

  RequestModel({
    this.id,
    this.item,
    this.requester,
    this.status,
    this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json['id'] as int?,
    item: json['item'] as int?,
    requester: json['requester'] == null
        ? null
        : UserModel.fromJson(json['requester'] as Map<String, dynamic>),
    status: json['status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item,
    'requester': requester?.toJson(),
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}
