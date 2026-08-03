import 'package:dealura/features/chat/models/chat_token_model.dart';

abstract class ChatRepository {
  Future<ChatTokenModel> getChatToken();
  Future<String> createChatForItem(int itemId);
}
