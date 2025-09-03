
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

  Future<void> sendFCMNotification(String title, String body, List<String> deviceTokens) async {
    /*
    const String projectId = 'PROJECT_ID';

    // FCM HTTP v1 endpoint
    const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    //Todo: Burada Handvibe için eklenecek
    String serviceText = await rootBundle.loadString('path');

    // Servis hesabı kimlik bilgilerini yükleyin
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      serviceText,
    );

    // OAuth2 erişim token'ı alın
    final authClient = await clientViaServiceAccount(
      serviceAccountCredentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    for (var token in deviceTokens) {
      final Map<String, dynamic> message = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
        },
      };

      final response = await authClient.post(
        Uri.parse(fcmEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('Bildirim başarıyla gönderildi: $token');
      } else {
        debugPrint('Bildirim gönderilemedi. Hata kodu: ${response.statusCode}');
        debugPrint('Sunucu cevabı: ${response.body}');
      }
    }

    authClient.close();*/
  }
}