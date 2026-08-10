import 'package:dealura/core/utls/chat_client.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatDetailsPage extends StatefulWidget {
  final Channel channel;

  const ChatDetailsPage({super.key, required this.channel});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  @override
  void initState() {
    super.initState();

    print('CHAT DETAILS INIT: Opening channel ${widget.channel.id}');
    print('  Channel type: ${widget.channel.type}');
    print('  Channel CID: ${widget.channel.cid}');
    print('  Current user: ${streamClient.state.currentUser?.id}');

    final members = widget.channel.state?.members;
    if (members != null) {
      print('  Channel members (${members.length}):');
      for (var member in members) {
        print('    - User ID: ${member.user?.id}, Name: ${member.user?.name}');
      }
    }

    final messages = widget.channel.state?.messages;
    if (messages != null) {
      print('  Existing messages (${messages.length}):');
      for (var message in messages) {
        print('    - Message ID: ${message.id}');
        print('      Text: ${message.text}');
        print('      Sender ID: ${message.user?.id}');
        print('      Sender Name: ${message.user?.name}');
        print('      Created at: ${message.createdAt}');
      }
    } else {
      print('  No existing messages found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const StreamChannelHeader(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 16.0,
                    vertical: isTablet ? 16.0 : 8.0,
                  ),
                  child: const StreamMessageListView(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24.0 : 16.0,
                  vertical: isTablet ? 16.0 : 8.0,
                ),
                child: StreamMessageComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
