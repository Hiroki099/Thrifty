class TokenModel {
  String? refresh;
  String? access;

  TokenModel({this.refresh, this.access});

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    refresh: json['refresh'] as String?,
    access: json['access'] as String?,
  );

}
