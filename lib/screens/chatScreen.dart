import 'package:chat_test/widgets/messages.dart';
import 'package:chat_test/widgets/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    notificationPermission();
    super.initState();
  }

  void getToken() async {
    print(await messaging.getToken());
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (item) {
                if (item == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(child: Messages()),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }

  void initMessaging() {
    var androidInit = AndroidInitializationSettings('ic_launcher');
    var iosInit = IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    FlutterLocalNotificationsPlugin().initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification();
    });
  }

  void showNotification() async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetail = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'title',
      'body',
      generalNotificationDetail,
      payload: 'Notification',
    );
  }

  void notificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
