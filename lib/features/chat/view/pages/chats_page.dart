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

    print('CHAT LIST INIT: streamClient.currentUser = ${streamClient.state.currentUser?.id}');
    print('CHAT LIST INIT: global currentUserId = $currentUserId');
    
    // Update currentUserId from streamClient if needed
    if (currentUserId == null && streamClient.state.currentUser != null) {
      currentUserId = streamClient.state.currentUser?.id;
      print('CHAT LIST INIT: Updated currentUserId from streamClient: $currentUserId');
    }

    final userId = streamClient.state.currentUser?.id;

    if (userId == null) {
      print('CHAT LIST ERROR: Stream user is not connected.');
      throw StateError('Stream user is not connected.');
    }

    print('CHAT LIST INIT: Using user ID = $userId');

    _controller = StreamChannelListController(
      client: streamClient,

      filter: Filter.and([
        Filter.equal('type', 'messaging'),
        Filter.in_('members', [userId]),
      ]),

      channelStateSort: const [
        SortOption<ChannelState>.desc('last_message_at'),
      ],
    );

    // Listen to channel updates
    _controller.addListener(() {
      // Note: In version 10.2.0, we can't directly access state
      // We'll rely on the StreamChannelListView to show the data
      print('CHAT LIST: Controller listener triggered');
    });
  }

  @override
  void dispose() {
    print('CHAT LIST DISPOSE: Disposing controller');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: streamClient,

      child: Scaffold(
        appBar: AppBar(title: const Text('Messages')),

        body: StreamChannelListView(
          controller: _controller,

          onChannelTap: (channel) {
            print('CHAT LIST TAP: Opening channel ${channel.id}');
            print('  Channel type: ${channel.type}');
            print('  Channel CID: ${channel.cid}');
            print('  Channel members: ${channel.state?.members.map((m) => m.user?.id).toList()}');
            print('  Channel created by: ${channel.createdBy?.id}');
            print('  Channel last message: ${channel.state?.lastMessage?.text}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailsPage(channel: channel),
              ),
            );
          },
          itemBuilder: (context, channels, index, defaultWidget) {
            final channel = channels[index];
            print('CHAT LIST ITEM: Channel ${channel.id}');
            
            // Only show channels that start with "item-" (created by our app)
            if (channel.id != null && channel.id!.startsWith('item-')) {
              print('CHAT LIST ITEM: Showing channel ${channel.id}');
              return defaultWidget;
            }
            
            print('CHAT LIST ITEM: Hiding channel ${channel.id} (not starting with "item-")');
            return const SizedBox.shrink(); // Hide other channels
          },
        ),
      ),
    );
  }
}
