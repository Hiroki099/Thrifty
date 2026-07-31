import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';

class RequestModel {
  int? id;
  int? itemId;
  ItemModel? itemDetails;
  UserModel? requester;
  String? status;
  DateTime? createdAt;

  RequestModel({
    this.id,
    this.itemId,
    this.itemDetails,
    this.requester,
    this.status,
    this.createdAt,
  });
  factory RequestModel.fromPartialJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as int?,
      itemId: (json['item'] as num?)?.toInt(),
      requester: json['requester'] == null
          ? null
          : UserModel.fromPartialJson(
              json['requester'] as Map<String, dynamic>,
            ),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final item = json['item'] == null
        ? null
        : ItemModel.fromJson(json['item'] as Map<String, dynamic>);

    return RequestModel(
      id: json['id'] as int?,
      itemId: item?.id,
      itemDetails: item,
      requester: json['requester'] == null
          ? null
          : UserModel.fromPartialJson(json['requester']),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
    );
  }
}
