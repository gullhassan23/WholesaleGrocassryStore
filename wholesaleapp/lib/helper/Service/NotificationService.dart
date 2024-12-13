import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/screens/homeScreen/navigation.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications
  void initLocalNotifications(BuildContext context) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    // Initialize the local notification plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context);
      },
    );
  }

  /// Request notification permissions
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      criticalAlert: true,
      provisional: true,
      sound: true,
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User provisionally granted permission");
    } else {
      Get.snackbar(
        "Notification permission denied",
        "Please allow notifications to receive updates",
        snackPosition: SnackPosition.TOP,
      );

      Future.delayed(const Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  /// Get the device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device token: $token");
    return token!;
  }

  /// Listen for token refresh
  void listenForTokenRefresh() async {
    messaging.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
    });
  }

  /// Show a notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Unique ID for the notification channel
      'High Importance Notifications', // Channel name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      showBadge: true,
      playSound: true,
    );

    // Define Android notification settings
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: channel.sound,
    );

    // Define iOS notification settings
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Merge settings for both platforms
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Show the notification
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: 'my-data',
    );
  }

  /// Initialize Firebase messaging
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        iosForegroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context);
        showNotification(message);
      }
    });
  }

  /// Configure iOS foreground notifications
  Future<void> iosForegroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Handle message interaction
  Future<void> handleMessage(BuildContext context) async {
    Get.to(() => HomeContentScreen);
  }

  /// Setup message interaction listeners
  Future<void> setupInteractMessage(BuildContext context) async {
    // Handle messages when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context);
    });

    // Handle messages when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(context);
      }
    });
  }

  Future<String?> getUserToken({required String collect}) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collect)
          .doc(currentUser.uid)
          .get();

      // Check if the token exists
      if (userDoc.exists && userDoc['fcmToken'] != null) {
        print("token====> ${userDoc['fcmToken']}");
        return userDoc['fcmToken'];
      }
    }
    return null;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('Token refreshed: $event');
    });
  }
}
