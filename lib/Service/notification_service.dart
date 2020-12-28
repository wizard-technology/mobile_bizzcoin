import 'dart:convert';
import 'dart:io';

import 'package:bizzcoin_app/Auth/LanguagePage.dart';
import 'package:bizzcoin_app/Screen/History/HistoryPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final context;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  PushNotificationService({this.context});
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        // print(message['data']['report']);
        // print(message['data']['history']);
        if (message['data']['history'] != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => HistoryPage(),
            ),
          );
        }
        // if (message['data']['report'] != null) {
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (BuildContext context) => LanguagePage(),
        //     ),
        //   );
        // }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future token() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    return _fcm.getToken();
  }
}
