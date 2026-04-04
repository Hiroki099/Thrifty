

class UserModel {
  int? id;
  String? username;
  String? email;
  String? profilePictureUrl;
  String? detailUrl;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.profilePictureUrl,
    this.detailUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
    id: data['id'] as int?,
    username: data['username'] as String?,
    email: data['email'] as String?,
    profilePictureUrl: data['profile_picture_url'] as String?,
    detailUrl: data['detail_url'] as String?,
  );


}
