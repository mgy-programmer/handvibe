
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint("Notification Title: ${message.notification?.title}");
    debugPrint("Notification Body: ${message.notification?.body}");
  }

  initFirebaseNotification() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String> getUserToken() async {
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      return token;
    } else {
      return "";
    }
  }
}
