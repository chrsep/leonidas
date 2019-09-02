import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  NotificationHelper() {
    localNotif.initialize(initSettings);
  }

  final localNotif = FlutterLocalNotificationsPlugin();
  final initSettings = InitializationSettings(
      AndroidInitializationSettings('ic_notification'), null);

  static final tracker = NotificationDetails(AndroidNotificationDetails(
    'workout session',
    'workout sesion',
    'For showing that workout tracking is on',
    ongoing: true,
    autoCancel: false,
    ticker: 'Aspis is tracking workout',
    importance: Importance.Low,
    playSound: false,
  ), null);

  // TODO(chrsep): didn't think this API through yet, revisit down the road.
  void send(NotificationDetails details, int id, String title, String body) {
    localNotif.show(0, title, body, details);
  }

  void cancel(int id) {
    localNotif.cancel(id);
  }
}
