import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifaction{

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  var _android;
  var _iOS;
  var _initSetttings;

  Notifaction(){
    this._flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    this._android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    this._iOS = new IOSInitializationSettings();
    this._initSetttings = new InitializationSettings(_android, _iOS);
    this._flutterLocalNotificationsPlugin.initialize(_initSetttings,
        onSelectNotification: null);
  }

  //  onSelectNotification(String payload) async {
  //   print("payload : $payload");
  // }

  showNotification(String content) async {
    var android = new AndroidNotificationDetails(
        'CHANNEL-1', 'channel', 'firest channel flutter app notifaction',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await this._flutterLocalNotificationsPlugin.show(
        0, 'new notifaction', content, platform,
        payload: 'notifaction not');
  }
}