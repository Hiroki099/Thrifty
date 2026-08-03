import 'package:dealura/core/utls/chat_client.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatDetailsPage extends StatelessWidget {
  final Channel channel;

  const ChatDetailsPage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: streamClient,
      child: StreamChannel(
        channel: channel,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                StreamChannelHeader(),
                Expanded(child: StreamMessageListView()),
                StreamMessageComposer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
