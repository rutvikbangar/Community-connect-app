import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void requestNotificationPermission () async {
    NotificationSettings setting = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    if(setting.authorizationStatus == AuthorizationStatus.authorized){
      print("Permission granted");

    }

    else if(setting.authorizationStatus == AuthorizationStatus.provisional){
      print("permission provisional granted");
    } else{
      print("permission denied");
    }

  }




  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
void isTokenRefresh() async {
   messaging.onTokenRefresh.listen((event) {
     event.toString();
     print("refresh");

   });
  }



}