import 'dart:convert';

class ImageModel {
  int? id;
  String? image;

  ImageModel({this.id, this.image});

  factory ImageModel.fromMap(Map<String, dynamic> data) =>
      ImageModel(id: data['id'] as int?, image: data['image'] as String?);

  Map<String, dynamic> toMap() => {'id': id, 'image': image};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ImageModel].
  factory ImageModel.fromJson(String data) {
    return ImageModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ImageModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
