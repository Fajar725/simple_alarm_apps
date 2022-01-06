import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

class NotificationConfig {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final BehaviorSubject<String> onNotification = BehaviorSubject<String>();
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  // static final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  // static final BehaviorSubject<ReceivedNotification> _didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

  static const AndroidInitializationSettings _initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  static final IOSInitializationSettings _initializationSettingsIOS = IOSInitializationSettings();

  static final MacOSInitializationSettings _initializationSettingsMacOS = MacOSInitializationSettings();

  static final InitializationSettings _initializationSettings = InitializationSettings(
    android: _initializationSettingsAndroid,
    iOS: _initializationSettingsIOS,
    macOS: _initializationSettingsMacOS
  );

  static const AndroidNotificationDetails _androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id', 
    'your channel name', 
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    sound: RawResourceAndroidNotificationSound('slow_spring_board')
  );

  static const NotificationDetails _platformChannelSpecifics = NotificationDetails(
    android: _androidPlatformChannelSpecifics,
    iOS: IOSNotificationDetails()
  );

  static Future<void> showNotification({
    int id = 0,
    String title = "Title",
    String body = "Body",
    String payload = "Payload"
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id, 
      title, 
      body, 
      _platformChannelSpecifics,
      payload: payload
    );
  }

  static Future<void> cancel() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showSceduleNotification(
    DateTime sceduleDate,  
    {
      int id = 0,
      String title = "Title",
      String body = "Body",
      String payload = "Payload"
    }
  ) async {
    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin. zonedSchedule(
      0, 
      title, 
      body,
      tz.TZDateTime.from(sceduleDate, tz.local), 
      _platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );


  }

  static Future initialize(BuildContext context) async {

    Future _selectNotification(String payload) async {

      if (payload != null) {
        debugPrint('notification payload: $payload');
        onNotification.add(payload);
      }

    }

    return await _flutterLocalNotificationsPlugin.initialize(
      _initializationSettings,
      onSelectNotification: _selectNotification
    );

  }

}