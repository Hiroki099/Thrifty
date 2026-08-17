import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/item_model.dart';

class ReportModel {
  final int? id;
  final UserModel? reporter;
  final ItemModel? reportedItem;
  final String? reason;
  final String? description;
  final String? status;
  final String? adminNotes;
  final DateTime? createdAt;
  final DateTime? resolvedAt;

  const ReportModel({
    this.id,
    this.reporter,
    this.reportedItem,
    this.reason,
    this.description,
    this.status,
    this.adminNotes,
    this.createdAt,
    this.resolvedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int?,

      reporter: json['reporter'] is Map<String, dynamic>
          ? UserModel.fromPartialJson(json['reporter'] as Map<String, dynamic>)
          : null,

      reportedItem: json['reported_item'] is Map<String, dynamic>
          ? ItemModel.fromJson(json['reported_item'] as Map<String, dynamic>)
          : null,

      reason: json['reason'] as String?,

      description: json['description'] as String?,

      status: json['status'] as String?,

      adminNotes: json['admin_notes'] as String?,

      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),

      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.tryParse(json['resolved_at'] as String),
    );
  }
}
