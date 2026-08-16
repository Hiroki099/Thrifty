import 'package:dealura/core/services/notification_services.dart';
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

    // Set this as the active channel to prevent notifications
    NotificationService.setActiveChannel(widget.channel.cid);

    print('CHAT DETAILS INIT: Opening channel ${widget.channel.id ?? "unknown"}');
    print('  Channel type: ${widget.channel.type }');
    print('  Channel CID: ${widget.channel.cid ?? "unknown"}');
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
        print('    - Message ID: ${message.id }');
        print('      Text: ${message.text ?? "empty"}');
        print('      Sender ID: ${message.user?.id}');
        print('      Sender Name: ${message.user?.name}');
        print('      Created at: ${message.createdAt}');
      }
    } else {
      print('  No existing messages found');
    }
  }

  @override
  void dispose() {
    // Clear the active channel when leaving
    NotificationService.clearActiveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    if (widget.channel.id == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF8F2),
        body: Center(
          child: Text('Channel not available'),
        ),
      );
    }

    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF8F2),
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
