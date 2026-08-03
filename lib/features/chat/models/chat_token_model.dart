class ChatTokenModel {
  String? token;
  String? userId;
  String? apiKey;

  ChatTokenModel({this.token, this.userId, this.apiKey});

  factory ChatTokenModel.fromJson(Map<String, dynamic> json) {
    return ChatTokenModel(
      token: json['token'] as String?,
      userId: json['user_id'] as String?,
      apiKey: json['api_key'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'user_id': userId,
    'api_key': apiKey,
  };
}
