import 'package:dealura/core/utls/api_service.dart';
import 'package:dealura/features/chat/models/chat_token_model.dart';
import 'package:dealura/features/chat/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
Future<String> createChatForItem(int itemId) async {
  final api = ApiService();
  final response = await api.post('chat/items/$itemId/', {});
  return response.data['channel_id'];
}

  @override
  Future<ChatTokenModel> getChatToken() async {
    final api = ApiService();
    final response = await api.get(endpoint: 'chat/token/');
    return (ChatTokenModel.fromJson(response));
  }
}
