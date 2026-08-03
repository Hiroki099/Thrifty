import 'package:dealura/features/chat/models/chat_token_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();
Future<void> saveTokens(String accessToken, String refreshToken) async {
  await storage.write(key: 'access_token', value: accessToken);
  await storage.write(key: 'refresh_token', value: refreshToken);
}

Future<void> saveChatTokens(ChatTokenModel chat) async {
  await storage.write(key: 'chat_token', value: chat.token);
  await storage.write(key: 'chat_user_id', value: chat.userId);
  await storage.write(key: 'chat_api_key', value: chat.apiKey);
}

Future<String?> getAccessToken() async {
  return await storage.read(key: 'access_token');
}

Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refresh_token');
}

Future<String?> getChatToken() async {
  return await storage.read(key: 'chat_token');
}

Future<String?> getChatUserId() async {
  return await storage.read(key: 'chat_user_id');
}

Future<String?> getChatApiKey() async {
  return await storage.read(key: 'chat_api_key');
}

Future<void> clearTokens() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');

  await storage.delete(key: 'chat_token');
  await storage.delete(key: 'chat_user_id');
  await storage.delete(key: 'chat_api_key');
}
