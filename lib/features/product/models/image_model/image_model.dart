class ImageModel {
  final int? id;
  final String? imageUrl;

  ImageModel({this.id, this.imageUrl});

  factory ImageModel.fromMap(Map<String, dynamic> data) {
    return ImageModel(id: data['id'], imageUrl: data['image_url']);
  }
}
