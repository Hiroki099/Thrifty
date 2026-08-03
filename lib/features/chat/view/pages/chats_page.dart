import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/features/chat/view/pages/chat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late final StreamChannelListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamChannelListController(
      client: streamClient,
      filter: currentUserId != null 
          ? Filter.in_('members', [currentUserId!])
          : Filter.empty(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: streamClient,
      child: Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: StreamChannelListView(
          controller: _controller,
          onChannelTap: (channel) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailsPage(channel: channel),
              ),
            );
          },
        ),
      ),
    );
  }
}
