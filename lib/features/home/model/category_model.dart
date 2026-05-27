class CategoryModel {
  final int? id;
  final String? name;
  final String? description;
  final dynamic parent;
  final String? detailUrl;

  const CategoryModel({
    this.id,
    this.name,
    this.description,
    this.parent,
    this.detailUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      parent: json['parent'],
      detailUrl: json['detail_url'] as String?,
    );
  }

  factory CategoryModel.fromPartialJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      detailUrl: json['detail_url'] as String?,
    );
  }
}
