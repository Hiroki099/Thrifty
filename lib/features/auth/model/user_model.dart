class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? profilePictureUrl;
  final String? detailUrl;
  final double? averageRating;
  final int? ratingCount;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.profilePictureUrl,
    this.detailUrl,
    this.averageRating,
    this.ratingCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      detailUrl: json['detail_url'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'] as int?,
    );
  }

  factory UserModel.fromPartialJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      detailUrl: json['detail_url'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      ratingCount: json['rating_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'detail_url': detailUrl,
      'average_rating': averageRating,
      'rating_count': ratingCount,
    };
  }
}
