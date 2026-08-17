import 'dart:async';
import 'dart:convert';

import 'package:dealura/core/utls/chat_client.dart';
import 'package:dealura/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream_chat;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('========================================');
  debugPrint('FCM BACKGROUND MESSAGE');
  debugPrint('ID: ${message.messageId}');
  debugPrint('TITLE: ${message.notification?.title}');
  debugPrint('BODY: ${message.notification?.body}');
  debugPrint('DATA: ${message.data}');
  debugPrint('TIMESTAMP: ${DateTime.now()}');
  debugPrint('========================================');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('FCM BACKGROUND: Firebase initialize result: $e');
  }

  final plugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings = InitializationSettings(
    android: androidSettings,
  );

  try {
    await plugin.initialize(settings: initializationSettings);
  } catch (e) {
    debugPrint('FCM BACKGROUND: Local notification initialization failed: $e');
    return;
  }

  const androidChannel = AndroidNotificationChannel(
    NotificationService.channelId,
    NotificationService.channelName,
    description: NotificationService.channelDescription,
    importance: Importance.high,
  );

  final androidImplementation = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  try {
    await androidImplementation?.createNotificationChannel(androidChannel);
  } catch (e) {
    debugPrint('FCM BACKGROUND: Channel creation failed: $e');
  }

  final title =
      message.notification?.title ??
      message.data['title']?.toString() ??
      'Dealura';

  final body =
      message.notification?.body ??
      message.data['body']?.toString() ??
      'New message';

  const androidDetails = AndroidNotificationDetails(
    NotificationService.channelId,
    NotificationService.channelName,
    channelDescription: NotificationService.channelDescription,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: '@mipmap/ic_launcher',
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  try {
    await plugin.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(message.data),
    );
    debugPrint('FCM BACKGROUND: Local notification displayed successfully');
  } catch (e, stackTrace) {
    debugPrint('FCM BACKGROUND: Failed to show notification: $e');
    debugPrint('$stackTrace');
  }
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'dealura_notifications';

  static const String channelName = 'Dealura Notifications';

  static const String channelDescription = 'Notifications from Dealura';

  // Using the custom Firebase provider name from Backend
  static const String streamPushProviderName = 'thrifty_notifications';

  static const String _lastRegisteredTokenKey = 'last_registered_fcm_token';
  static const String _lastRegisteredUserIdKey = 'last_registered_user_id';

  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;

  StreamSubscription<String>? _tokenRefreshSubscription;

  StreamSubscription<RemoteMessage>? _notificationTapSubscription;

  StreamSubscription<stream_chat.Event>? _streamEventSubscription;

  bool _initialized = false;

  bool _streamListenerStarted = false;

  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('NOTIFICATION: Already initialized');
      return;
    }

    debugPrint('========================================');

    debugPrint('NOTIFICATION: Initializing...');

    debugPrint('========================================');

    await _initializeLocalNotifications();

    await _createAndroidChannel();

    await _requestPermission();

    await _getToken();

    _listenToTokenRefresh();

    _listenToForegroundMessages();

    _listenToNotificationTap();

    await checkInitialMessage();

    _initialized = true;

    debugPrint('NOTIFICATION: Initialization completed');

    await _testFcmFunctionality();
  }

  Future<void> _testFcmFunctionality() async {
    debugPrint('========================================');
    debugPrint('FCM: Testing FCM functionality...');
    debugPrint('========================================');

    final token = await _messaging.getToken();
    if (token != null) {
      debugPrint('FCM: Token exists: ${token.substring(0, 20)}...');
      debugPrint('FCM: This means FCM is properly configured');
    } else {
      debugPrint('FCM: ERROR - No FCM token found!');
    }

    debugPrint('========================================');
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    /// Android 13+
    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> _createAndroidChannel() async {
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(androidChannel);
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM AUTH: ${settings.authorizationStatus}');
  }

  Future<String?> _getToken() async {
    try {
      final token = await _messaging.getToken();

      debugPrint('========================================');

      debugPrint('FCM TOKEN: $token');

      debugPrint('========================================');

      return token;
    } catch (e, stackTrace) {
      debugPrint('FCM TOKEN ERROR: $e');

      debugPrint('$stackTrace');

      return null;
    }
  }

  Future<void> registerStreamDevice({bool force = false}) async {
    try {
      final user = streamClient.state.currentUser;

      if (user == null) {
        debugPrint('STREAM PUSH: User is not connected.');
        return;
      }

      final token = await _messaging.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('STREAM PUSH: FCM token is null/empty.');
        return;
      }

      // Check if we need to re-register
      if (!force) {
        final prefs = await SharedPreferences.getInstance();
        final lastRegisteredToken = prefs.getString(_lastRegisteredTokenKey);
        final lastRegisteredUserId = prefs.getString(_lastRegisteredUserIdKey);

        if (lastRegisteredToken == token && lastRegisteredUserId == user.id) {
          debugPrint(
            'STREAM PUSH: Device already registered with same token and user. Skipping.',
          );
          return;
        }
      }

      debugPrint('========================================');

      debugPrint('STREAM PUSH: Registering device...');

      debugPrint('STREAM PUSH: user=${user.id}');

      debugPrint('STREAM PUSH: provider=firebase');

      debugPrint('STREAM PUSH: token=$token');

      debugPrint('========================================');

      await streamClient.addDevice(
        token,
        stream_chat.PushProvider.firebase,
        pushProviderName: streamPushProviderName,
      );

      debugPrint('========================================');

      debugPrint('STREAM PUSH: Device registered SUCCESSFULLY');
      debugPrint('========================================');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRegisteredTokenKey, token);
      await prefs.setString(_lastRegisteredUserIdKey, user.id);

      debugPrint('STREAM PUSH: Registration info saved locally');

      try {
        final devices = await streamClient.getDevices();
        debugPrint(
          'STREAM PUSH: Verification - Devices response: ${devices.toString()}',
        );

        if (devices.toString().contains('firebase')) {
          debugPrint('STREAM PUSH: Firebase device found in registration');
        } else {
          debugPrint(
            'STREAM PUSH: WARNING: No Firebase device found in registration',
          );
        }
      } catch (e) {
        debugPrint('STREAM PUSH: Verification failed: $e');
      }
    } catch (e, stackTrace) {
      debugPrint('========================================');

      debugPrint('STREAM PUSH ERROR: $e');

      debugPrint('STACKTRACE:');

      debugPrint('$stackTrace');

      debugPrint('========================================');
    }
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (newToken) async {
        debugPrint('FCM TOKEN REFRESHED: $newToken');

        if (streamClient.state.currentUser == null) {
          debugPrint('STREAM PUSH: User not connected yet.');

          return;
        }

        try {
          await streamClient.addDevice(
            newToken,
            stream_chat.PushProvider.firebase,
            pushProviderName: streamPushProviderName,
          );

          debugPrint('STREAM PUSH: Refreshed token registered SUCCESSFULLY');
        } catch (e, stackTrace) {
          debugPrint('STREAM TOKEN ERROR: $e');

          debugPrint('$stackTrace');
        }
      },
      onError: (error) {
        debugPrint('FCM TOKEN REFRESH ERROR: $error');
      },
    );
  }

  void _listenToForegroundMessages() {
    _foregroundMessageSubscription?.cancel();

    _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        debugPrint('========================================');

        debugPrint('FCM: FOREGROUND MESSAGE');

        debugPrint('FCM ID: ${message.messageId}');

        debugPrint('FCM TITLE: ${message.notification?.title}');

        debugPrint('FCM BODY: ${message.notification?.body}');

        debugPrint('FCM DATA: ${message.data}');

        debugPrint('========================================');

        await _showForegroundNotification(message);
      },
      onError: (error) {
        debugPrint('FCM FOREGROUND ERROR: $error');
      },
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    debugPrint(
      'FCM: Ignoring FCM message in foreground to avoid duplicate notifications',
    );
    return;
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
    required int id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(payload),
    );
  }

  void listenToStreamMessages() {
    debugPrint('STREAM: listenToStreamMessages()');

    if (_streamListenerStarted) {
      debugPrint('STREAM: Listener already started.');

      return;
    }

    if (streamClient.state.currentUser == null) {
      debugPrint('STREAM: User is not connected.');

      return;
    }

    _streamListenerStarted = true;

    debugPrint('STREAM: Starting foreground listener...');

    _streamEventSubscription = streamClient.on().listen(
      (event) async {
        if (event.type == 'connection.changed') {
          return;
        }

        debugPrint('STREAM EVENT: ${event.type}');

        if (event.type != 'message.new' &&
            event.type != 'notification.message_new') {
          return;
        }

        final message = event.message;

        if (message == null) {
          return;
        }

        debugPrint('========================================');

        debugPrint('STREAM: NEW MESSAGE');

        debugPrint('STREAM: ID = ${message.id}');

        debugPrint('STREAM: TEXT = ${message.text}');

        debugPrint('STREAM: SENDER = ${message.user?.id}');

        debugPrint('STREAM: CHANNEL = ${event.cid}');

        debugPrint('========================================');

        if (message.user?.id == currentUserId) {
          debugPrint('STREAM: Own message. Skip notification.');

          return;
        }

        if (message.text != null &&
            message.text!.toLowerCase().contains('congratulations')) {
          debugPrint('STREAM: Auction win message detected');
          debugPrint('STREAM: This should show notification as well');
        }

        await _showStreamNotification(message, event.cid);
      },
      onError: (error) {
        debugPrint('STREAM LISTENER ERROR: $error');
      },
    );

    _keepWebSocketAlive();
  }

  void _keepWebSocketAlive() {
    if (streamClient.state.currentUser == null) {
      return;
    }

    try {
      debugPrint('STREAM: WebSocket keep-alive subscription created');

      streamClient.queryUsers(
        filter: Filter.equal('id', streamClient.state.currentUser!.id),
      );

      _watchUserChannels();
      _startKeepAliveTimer();
    } catch (e) {
      debugPrint('STREAM: Failed to create keep-alive subscription: $e');
    }
  }

  Timer? _keepAliveTimer;

  static String? _activeChannelId;

  static void setActiveChannel(String? channelId) {
    _activeChannelId = channelId;
    debugPrint('STREAM: Active channel set to: $channelId');
  }

  static void clearActiveChannel() {
    debugPrint('STREAM: Active channel cleared');
    _activeChannelId = null;
  }

  void _startKeepAliveTimer() {
    _keepAliveTimer?.cancel();

    _keepAliveTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (streamClient.state.currentUser != null) {
        try {
          streamClient.queryUsers(
            filter: Filter.equal('id', streamClient.state.currentUser!.id),
          );
          debugPrint('STREAM: Keep-alive ping sent');
        } catch (e) {
          debugPrint('STREAM: Keep-alive ping failed: $e');
        }
      }
    });

    debugPrint('STREAM: Keep-alive timer started (30s interval)');
  }

  Future<void> _watchUserChannels() async {
    if (streamClient.state.currentUser == null) {
      return;
    }

    try {
      debugPrint('STREAM: Watching user channels...');

      final userId = streamClient.state.currentUser!.id;

      final channelsStream = streamClient.queryChannels(
        filter: Filter.and([
          Filter.equal('type', 'messaging'),
          Filter.in_('members', [userId]),
        ]),
      );
      final channelsList = await channelsStream.first;

      debugPrint('STREAM: Found ${channelsList.length} channels');

      for (var channel in channelsList) {
        try {
          await channel.watch();
          debugPrint('STREAM: Watching channel ${channel.id}');
        } catch (e) {
          debugPrint('STREAM: Failed to watch channel ${channel.id}: $e');
        }
      }

      debugPrint('STREAM: User channels watching completed');
    } catch (e) {
      debugPrint('STREAM: Failed to watch user channels: $e');
    }
  }

  Future<void> _showStreamNotification(
    stream_chat.Message message,
    String? cid,
  ) async {
    final text = message.text;

    if (text == null || text.isEmpty) {
      return;
    }

    if (_isUserInActiveChannel(cid)) {
      debugPrint('STREAM: User is in active channel, skipping notification');
      return;
    }

    final senderName = message.user?.name ?? 'Dealura';

    await _showNotification(
      title: senderName,
      body: text,
      payload: {'type': 'chat', 'cid': cid, 'message_id': message.id},
      id: message.id.hashCode,
    );
  }

  bool _isUserInActiveChannel(String? channelId) {
    if (channelId == null || _activeChannelId == null) {
      return false;
    }

    // Check if the incoming message is from the currently active channel
    final isActive = channelId == _activeChannelId;

    if (isActive) {
      debugPrint('STREAM: Message from active channel, skipping notification');
    }

    return isActive;
  }

  void _listenToNotificationTap() {
    _notificationTapSubscription?.cancel();

    _notificationTapSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('FCM: NOTIFICATION CLICKED');

        debugPrint('FCM DATA: ${message.data}');

        _handleNotificationData(message.data);
      },
      onError: (error) {
        debugPrint('FCM TAP ERROR: $error');
      },
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('LOCAL NOTIFICATION CLICKED');

    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);

      if (decoded is Map) {
        _handleNotificationData(Map<String, dynamic>.from(decoded));
      }
    } catch (e) {
      debugPrint('LOCAL TAP ERROR: $e');
    }
  }

  Future<void> checkInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message == null) {
      return;
    }

    debugPrint('========================================');

    debugPrint('FCM: APP OPENED FROM TERMINATED');

    debugPrint('FCM ID: ${message.messageId}');

    debugPrint('FCM DATA: ${message.data}');

    debugPrint('========================================');

    _handleNotificationData(message.data);
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return;
    }

    debugPrint('NOTIFICATION DATA: $data');

    final cid = data['cid']?.toString() ?? data['channel_id']?.toString();

    final messageId = data['message_id']?.toString() ?? data['id']?.toString();

    debugPrint('NOTIFICATION CID: $cid');

    debugPrint('NOTIFICATION MESSAGE ID: $messageId');
  }

  Future<void> onResume() async {
    debugPrint('STREAM PUSH: App resumed from background');

    if (streamClient.state.currentUser != null) {
      debugPrint('STREAM PUSH: Force re-registering device after background');
      await registerStreamDevice(force: true);

      if (!_streamListenerStarted) {
        listenToStreamMessages();
      }

      await _watchUserChannels();
    }
  }

  void onPause() {
    debugPrint('STREAM: Pausing for background - stopping WebSocket listener');
    stopStreamListener();
  }

  void stopStreamListener() {
    if (_streamEventSubscription != null) {
      _streamEventSubscription?.cancel();
      _streamEventSubscription = null;
      _streamListenerStarted = false;
      debugPrint(
        'STREAM: Listener stopped to avoid duplicate notifications with FCM',
      );
    }
  }

  Future<void> clearRegistrationInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastRegisteredTokenKey);
      await prefs.remove(_lastRegisteredUserIdKey);
      debugPrint('STREAM PUSH: Registration info cleared');
    } catch (e) {
      debugPrint('STREAM PUSH: Failed to clear registration info: $e');
    }
  }

  Future<void> dispose() async {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    await _foregroundMessageSubscription?.cancel();

    await _notificationTapSubscription?.cancel();

    await _tokenRefreshSubscription?.cancel();

    await _streamEventSubscription?.cancel();

    _foregroundMessageSubscription = null;

    _notificationTapSubscription = null;

    _tokenRefreshSubscription = null;

    _streamEventSubscription = null;

    _streamListenerStarted = false;

    _initialized = false;
  }

  Future<void> disconnectStream() async {
    try {
      debugPrint('STREAM: Disconnecting user...');

      stopStreamListener();

      _keepAliveTimer?.cancel();
      _keepAliveTimer = null;

      if (streamClient.state.currentUser != null) {
        await streamClient.disconnectUser();
      }

      currentUserId = null;

      debugPrint('STREAM: User disconnected successfully');
    } catch (e, stackTrace) {
      debugPrint('STREAM: Disconnect failed: $e');
      debugPrint('$stackTrace');
    } finally {
      _streamListenerStarted = false;
    }
  }
}
