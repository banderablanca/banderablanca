import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/models.dart';

class FirebaseNotifications {
  // FirebaseNotifications({
  //   this.onMessage,
  //   this.onResume,
  //   this.onLaunch,
  //   this.onSaveToken,
  // });

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late Function(Map<String, dynamic> message) onMessage;
  late Function(Map<String, dynamic> message) onResume;
  late Function(Map<String, dynamic> message) onLaunch;
  late Function(String) onSaveToken;

  void setUpFirebase() {
    firebaseCloudMessagingListeners();
  }

  void subscribe(WhiteFlag flag) {
    final String topic = '${flag}NewComments';
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void unSubscribe(WhiteFlag flag) {
    final String topic = '${flag}NewComments';
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void firebaseCloudMessagingListeners() {
    // _firebaseMessaging.autoInitEnabled();
    // if (Platform.isIOS) iOSPermission();
    _firebaseMessaging.getToken().then((token) {
      if (token != null) return onSaveToken(token);
    });
    // FirebaseMessaging.onMessageOpenedApp();

// _firebaseMessaging.onMessageOpenedApp
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) {
    //     // disabled for Bug:
    //     // https://github.com/FirebaseExtended/flutterfire/issues/1669
    //     // return onMessage(message);
    //     // print(message);
    //   },
    //   onResume: (Map<String, dynamic> message) {
    //     return onResume(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) {
    //     return onLaunch(message);
    //   },
    // );
  }

  // void iOSPermission() {
  //   _firebaseMessaging.requestPermission(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {});
  // }
}
