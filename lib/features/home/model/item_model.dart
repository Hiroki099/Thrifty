import 'package:dealura/features/auth/model/user_model.dart';
import 'package:dealura/features/home/model/category_model.dart';

class ItemModel {
  int? id;
  String? name;
  String? listingType;
  String? price;
  CategoryModel? category;
  UserModel? owner;
  String? description;
  bool? isAvailable;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? detailUrl;
  String? image;

  ItemModel({
    this.id,
    this.name,
    this.listingType,
    this.price,
    this.category,
    this.owner,
    this.description,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.detailUrl,
    this.image,
  });

  factory ItemModel.fromJson(Map<String, dynamic> data) => ItemModel(
    id: data['id'] as int?,
    name: data['name'] as String?,
    listingType: data['listing_type'] as String?,
    price: data['price'] as String?,
    category: data['category'] is Map<String, dynamic>
        ? CategoryModel.fromPartialJson(data['category'])
        : CategoryModel(id: data['category'] as int?),
    owner: data['owner'] == null
        ? null
        : UserModel.fromPartialJson(data['owner'] as Map<String, dynamic>),
    description: data['description'] as String?,
    isAvailable: data['is_available'] as bool?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.parse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.parse(data['updated_at'] as String),
    detailUrl: data['detail_url'] as String?,
    image: data['image'] as String?,
  );
}
