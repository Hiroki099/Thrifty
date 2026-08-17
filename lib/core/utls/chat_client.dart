import 'package:stream_chat_flutter/stream_chat_flutter.dart';

StreamChatClient streamClient = StreamChatClient(
  'placeholder',
  logLevel: Level.OFF,
);

String? currentUserId;

void resetStreamClient(String apiKey) {
  streamClient = StreamChatClient(apiKey, logLevel: Level.OFF);
}