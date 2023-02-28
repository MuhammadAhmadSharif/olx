import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    // if (Platform.isIOS) {
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }
    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    // print("FirebaseMessaging token: $token");
    void _showTopPopup(title) {
      builder:
      (context) {
        return Container(
          height: 45,
          child: Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
// SizedBox(
// width: MediaQuery.of(context).size.width * 0.1,
// ),
                ],
              ),
            ),
          ),
        );
      };
    }

    void showOverlay(BuildContext context, {required dynamic title}) async {
      OverlayState? overlayState = Overlay.of(context);
      OverlayEntry overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
      overlayState!.insert(overlayEntry);
      await Future.delayed(Duration(seconds: 2));
      overlayEntry.remove();
    }

    //only works if app in foreground (Running)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Extract the notification data
        var notificationTitle = message.notification!.title;
        var notificationBody = message.notification!.body;
        log(notificationBody.toString());
        log(notificationTitle.toString());
        // Fluttertoast.showToast(
        //     msg: notificationBody.toString(),
        //     // toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        // showOverlay(context, title: notificationBody.toString());

        // _showTopPopup(notificationTitle);
      }

      // showNotification(notificationTitle!, notificationBody!);
    });
//onclick notif system tray only works if app in background but not terminate
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        log("I am Working perfectly");
        // RemoteNotification? notification = message.notification;
        // AndroidNotification? android = message.notification?.android;
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          // Extract the notification data
          var notificationTitle = message.notification!.title;
          var notificationBody = message.notification!.body;
          _showTopPopup(notificationTitle);
        }
      },
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Message also contained a notification: ${message.notification}');
        // Extract the notification data
        var notificationTitle = message.notification!.title;
        var notificationBody = message.notification!.body;
        log("I am running kkkkkkkkkkkkkkkkkkkkk");
        _showTopPopup(notificationTitle);
      }
    });
  }
}
