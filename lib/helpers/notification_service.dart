
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings
  = AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

  Future<void> showNotifications(String itemName) async{
    print("📢 Showing notification for: $itemName");

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('cart_channel', 'Cart Notifications', playSound: true);


  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(0, 'New Item in cart', "$itemName  added to cart", notificationDetails);
}

