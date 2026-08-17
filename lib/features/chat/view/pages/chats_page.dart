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

    print(
      'CHAT LIST INIT: '
      'streamClient.currentUser = '
      '${streamClient.state.currentUser?.id}',
    );

    print(
      'CHAT LIST INIT: '
      'global currentUserId = '
      '$currentUserId',
    );

    // --------------------------------------------------
    // Update currentUserId if needed
    // --------------------------------------------------

    if (currentUserId == null && streamClient.state.currentUser != null) {
      currentUserId = streamClient.state.currentUser?.id;

      print(
        'CHAT LIST INIT: '
        'Updated currentUserId = '
        '$currentUserId',
      );
    }

    // --------------------------------------------------
    // Get Stream user
    // --------------------------------------------------

    final userId = streamClient.state.currentUser?.id;

    if (userId == null) {
      print(
        'CHAT LIST ERROR: '
        'Stream user is not connected.',
      );

      throw StateError('Stream user is not connected.');
    }

    print(
      'CHAT LIST INIT: '
      'Using user ID = $userId',
    );

    // --------------------------------------------------
    // Channel controller
    // --------------------------------------------------

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

    _controller.addListener(() {
      print('CHAT LIST: Controller listener triggered');
    });
  }

  @override
  void dispose() {
    print(
      'CHAT LIST DISPOSE: '
      'Disposing controller',
    );

    _controller.dispose();

    super.dispose();
  }

  // ====================================================
  // Get item name safely
  // ====================================================

  String? _getItemName(Channel channel) {
    final value = channel.extraData['item_name'];

    if (value == null) {
      return null;
    }

    final name = value.toString().trim();

    if (name.isEmpty) {
      return null;
    }

    return name;
  }

  // ====================================================
  // Item name widget
  // ====================================================

  Widget _buildItemName(String itemName, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTablet ? 76 : 72,
        right: 12,
        top: 0,
        bottom: 6,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xffF1ECE5),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 13,
                color: Color(0xff8E8982),
              ),

              const SizedBox(width: 5),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isTablet ? 300 : 220),
                child: Text(
                  itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6F6A64),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),

      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w600,
          ),
        ),

        backgroundColor: const Color(0xFFFBF8F2),

        elevation: 0,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24.0 : 16.0,
          vertical: isTablet ? 16.0 : 8.0,
        ),

        child: StreamChannelListView(
          controller: _controller,

          // ============================================
          // Open channel
          // ============================================
          onChannelTap: (channel) {
            print(
              'CHAT LIST TAP: '
              'Opening channel ${channel.id}',
            );

            print(
              'Channel type: '
              '${channel.type}',
            );

            print(
              'Channel CID: '
              '${channel.cid}',
            );

            print(
              'Channel members: '
              '${channel.state?.members.map((m) => m.user?.id).toList()}',
            );

            print(
              'Channel created by: '
              '${channel.createdBy?.id}',
            );

            print(
              'Channel last message: '
              '${channel.state?.lastMessage?.text}',
            );

            print(
              'Channel extraData: '
              '${channel.extraData}',
            );

            print(
              'Channel item_name: '
              '${_getItemName(channel)}',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailsPage(channel: channel),
              ),
            );
          },

          // ============================================
          // Custom item
          // ============================================
          itemBuilder: (context, channels, index, defaultWidget) {
            final channel = channels[index];

            print(
              'CHAT LIST ITEM: '
              'Channel ${channel.id}',
            );

            // ------------------------------------------------
            // Only show channels created by our app
            // ------------------------------------------------

            if (channel.id == null || !channel.id!.startsWith('item-')) {
              print(
                'CHAT LIST ITEM: '
                'Hiding channel '
                '${channel.id}',
              );

              return const SizedBox.shrink();
            }
            print(
              'CHAT LIST ITEM: '
              'Showing channel '
              '${channel.id}',
            );

            final itemName = _getItemName(channel);

            // ------------------------------------------------
            // Old channels:
            // No item_name -> show original widget
            // ------------------------------------------------

            if (itemName == null) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 12.0 : 8.0),
                child: defaultWidget,
              );
            }

            // ------------------------------------------------
            // New channels:
            // Show original Stream tile + item name
            // ------------------------------------------------

            return Padding(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 8.0 : 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [defaultWidget, _buildItemName(itemName, isTablet)],
              ),
            );
          },
        ),
      ),
    );
  }
}
