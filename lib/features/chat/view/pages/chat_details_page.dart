  import 'package:dealura/core/services/notification_services.dart';
import 'package:dealura/core/utls/chat_client.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatDetailsPage extends StatefulWidget {
  final Channel channel;

  const ChatDetailsPage({
    super.key,
    required this.channel,
  });

  @override
  State<ChatDetailsPage> createState() =>
      _ChatDetailsPageState();
}

class _ChatDetailsPageState
    extends State<ChatDetailsPage> {
  bool _isLoading = true;
  String? _errorMessage;

  String? get itemName {
    final value =
        widget.channel.extraData['item_name'];

    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  @override
  void initState() {
    super.initState();

    debugPrint('========================================');
    debugPrint('CHAT DETAILS INIT');
    debugPrint(
      'Channel ID: ${widget.channel.id}',
    );
    debugPrint(
      'Channel CID: ${widget.channel.cid}',
    );
    debugPrint(
      'Channel type: ${widget.channel.type}',
    );
    debugPrint(
      'Current user: '
      '${streamClient.state.currentUser?.id}',
    );
    debugPrint(
      'Item name: $itemName',
    );
    debugPrint(
      'Extra data: '
      '${widget.channel.extraData}',
    );
    debugPrint('========================================');

    _initializeChannel();
  }

  Future<void> _initializeChannel() async {
    try {
      // --------------------------------------------------
      // Check Stream user
      // --------------------------------------------------

      final currentUser =
          streamClient.state.currentUser;

      if (currentUser == null) {
        throw Exception(
          'Stream user is not connected.',
        );
      }

      debugPrint(
        'CHAT DETAILS: Current user = '
        '${currentUser.id}',
      );

      // --------------------------------------------------
      // Check CID
      // --------------------------------------------------

      final cid = widget.channel.cid;

      if (cid == null || cid.isEmpty) {
        throw Exception(
          'Channel CID is null or empty.',
        );
      }

      debugPrint(
        'CHAT DETAILS: Preparing channel $cid',
      );

      // --------------------------------------------------
      // Notification active channel
      // --------------------------------------------------

      NotificationService.setActiveChannel(cid);

      // --------------------------------------------------
      // Watch channel only when state is not available
      // --------------------------------------------------

      if (widget.channel.state == null) {
        debugPrint(
          'CHAT DETAILS: Channel state is null.',
        );

        debugPrint(
          'CHAT DETAILS: Watching channel...',
        );

        await widget.channel.watch();

        debugPrint(
          'CHAT DETAILS: Channel watch completed.',
        );
      } else {
        debugPrint(
          'CHAT DETAILS: Channel state already available.',
        );
      }

      // --------------------------------------------------
      // Make sure state exists
      // --------------------------------------------------

      final channelState =
          widget.channel.state;

      if (channelState == null) {
        throw Exception(
          'Unable to load channel state.',
        );
      }

      debugPrint(
        'CHAT DETAILS: Channel state available.',
      );

      debugPrint(
        'CHAT DETAILS: Members = '
        '${channelState.members.length}',
      );

      debugPrint(
        'CHAT DETAILS: Messages = '
        '${channelState.messages.length}',
      );

      // --------------------------------------------------
      // Debug members
      // --------------------------------------------------
  for (final member
          in channelState.members) {
        debugPrint(
          'Member: '
          '${member.user?.id} / '
          '${member.user?.name}',
        );
      }

      // --------------------------------------------------
      // Debug messages
      // --------------------------------------------------

      for (final message
          in channelState.messages) {
        debugPrint(
          'Message: '
          '${message.id} / '
          '${message.text} / '
          '${message.user?.id}',
        );
      }

      // --------------------------------------------------
      // Debug extra data
      // --------------------------------------------------

      debugPrint(
        'CHAT DETAILS: Extra data = '
        '${widget.channel.extraData}',
      );

      debugPrint(
        'CHAT DETAILS: Item name = '
        '$itemName',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });

      debugPrint(
        'CHAT DETAILS: Initialization completed.',
      );
    } catch (e, stackTrace) {
      debugPrint('========================================');
      debugPrint('CHAT DETAILS ERROR');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE:');
      debugPrint('$stackTrace');
      debugPrint('========================================');

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _retry() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _initializeChannel();
  }

  @override
  void dispose() {
    debugPrint(
      'CHAT DETAILS DISPOSE: Clearing active channel',
    );

    NotificationService.clearActiveChannel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final isTablet =
        screenWidth > 600;

    // --------------------------------------------------
    // Invalid channel
    // --------------------------------------------------

    if (widget.channel.id == null) {
      return _buildErrorScreen(
        'Channel not available.',
      );
    }

    // --------------------------------------------------
    // Loading
    // --------------------------------------------------

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFFBF8F2),
        body: const SafeArea(
          child: Center(
            child:
                CircularProgressIndicator(),
          ),
        ),
      );
    }

    // --------------------------------------------------
    // Error
    // --------------------------------------------------

    if (_errorMessage != null) {
      return _buildErrorScreen(
        _errorMessage!,
        showRetry: true,
      );
    }

    // --------------------------------------------------
    // State check
    // --------------------------------------------------

    if (widget.channel.state == null) {
      return _buildErrorScreen(
        'Unable to load channel state.',
        showRetry: true,
      );
    }

    // --------------------------------------------------
    // Chat
    // --------------------------------------------------

    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        backgroundColor:
            const Color(0xFFFBF8F2),
        body: SafeArea(
          child: Column(
            children: [
              // ------------------------------------------------
              // Header
              // ------------------------------------------------

              const StreamChannelHeader(),

              // ------------------------------------------------
              // Messages
              // ------------------------------------------------
  Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isTablet ? 24.0 : 16.0,
                    vertical:
                        isTablet ? 16.0 : 8.0,
                  ),
                  child:
                      const StreamMessageListView(),
                ),
              ),

              // ------------------------------------------------
              // Composer
              // ------------------------------------------------

              Padding(
                padding: EdgeInsets.only(
                  left: isTablet ? 24.0 : 16.0,
                  right: isTablet ? 24.0 : 16.0,
                  top: 8.0,
                  bottom: isTablet ? 16.0 : 8.0,
                ),
                child:
                     StreamMessageComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(
    String message, {
    bool showRetry = false,
  }) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFBF8F2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: Colors.grey,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Unable to open chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w600,
                  ),
                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign:
                      TextAlign.center,
                ),

                if (showRetry) ...[
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _retry,
                    child: const Text(
                      'Try Again',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}