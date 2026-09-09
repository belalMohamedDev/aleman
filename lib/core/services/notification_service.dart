import 'dart:convert';
import 'dart:io';

import 'package:aleman/core/application/di.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/routing/notification_router.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';
import 'package:aleman/feature/notification/data/model/request/register_token_request_body.dart';
import 'package:aleman/feature/notification/domain/usecase/register_device_token_use_case.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  appLogger.info('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _highImportanceChannel =
      AndroidNotificationChannel(
    'aleman_high_importance_channel',
    'إشعارات الإيمان الهامة',
    description: 'تنبيهات حالة الطلبات والعروض الحصرية للإيمان للأعلاف',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. Initialize Firebase if not already initialized
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
          appLogger.info('Firebase Core initialized in NotificationService');
        }
      } catch (e) {
        appLogger.warning('Firebase.initializeApp() skipped or failed: $e');
      }

      // 2. Setup Local Notifications (Android & iOS)
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          appLogger.info('Notification clicked with payload: ${response.payload}');
          if (response.payload != null && response.payload!.isNotEmpty) {
            NotificationRouter.handleNavigation(response.payload);
          }
        },
      );

      // Create Android Notification Channel
      final androidPlatform = _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        await androidPlatform.createNotificationChannel(_highImportanceChannel);
      }

      // 3. Request permissions
      await _requestPermissions();

      // 4. Register Background Handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 5. Handle Foreground Notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        appLogger.info('Foreground notification received: ${message.notification?.title}');
        _showLocalNotification(message);
      });

      // 6. Handle Background Notification Click (App opened from background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        appLogger.info('Notification opened app from background: ${message.data}');
        NotificationRouter.handleNavigation(message.data);
      });

      // 7. Handle Terminated Notification Click (App opened from killed state)
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        appLogger.info('App opened from terminated state via notification: ${initialMessage.data}');
        NotificationRouter.setPendingPayload(initialMessage.data);
      }

      // 8. Setup FCM Token and Refresh Listener
      await _setupFcmToken();

      _isInitialized = true;
      appLogger.info('NotificationService fully initialized successfully');
    } catch (e, stack) {
      appLogger.error('Failed to initialize NotificationService: $e', stack);
    }
  }

  Future<void> _requestPermissions() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // iOS permission
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Android 13+ permission
      if (Platform.isAndroid) {
        final androidImplementation = _localNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidImplementation?.requestNotificationsPermission();
      }

      // Foreground presentation options for iOS
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      appLogger.warning('Error requesting notification permissions: $e');
    }
  }

  Future<void> _setupFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final String? token = await messaging.getToken();

      if (token != null && token.isNotEmpty) {
        appLogger.info('Retrieved FCM Token: $token');
        await SharedPrefHelper.setSecuredString(PrefKeys.fcmDeviceToken, token);
        await syncTokenWithBackend(token);
      }

      // Listen for token updates
      messaging.onTokenRefresh.listen((newToken) async {
        appLogger.info('FCM Token refreshed: $newToken');
        await SharedPrefHelper.setSecuredString(PrefKeys.fcmDeviceToken, newToken);
        await syncTokenWithBackend(newToken);
      });
    } catch (e) {
      appLogger.warning('Could not get or refresh FCM token: $e');
    }
  }

  Future<void> syncTokenWithBackend([String? token]) async {
    try {
      final fcmToken = token ??
          await SharedPrefHelper.getSecuredString(PrefKeys.fcmDeviceToken);

      if (fcmToken.isEmpty) return;

      if (instance.isRegistered<RegisterDeviceTokenUseCase>()) {
        final registerUseCase = instance<RegisterDeviceTokenUseCase>();
        final deviceType = Platform.isIOS ? 'ios' : 'android';

        final result = await registerUseCase.execute(
          RegisterTokenRequestBody(
            fcmToken: fcmToken,
            deviceType: deviceType,
            appVersion: '1.0.0',
          ),
        );

        result.when(
          success: (res) {
            appLogger.info('Device token registered with backend: ${res.message}');
          },
          failure: (err) {
            appLogger.warning('Failed to register device token with backend: ${err.message}');
          },
        );
      }
    } catch (e) {
      appLogger.warning('syncTokenWithBackend error: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _highImportanceChannel.id,
      _highImportanceChannel.name,
      channelDescription: _highImportanceChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  Future<String> getStoredToken() async {
    return await SharedPrefHelper.getSecuredString(PrefKeys.fcmDeviceToken);
  }
}
