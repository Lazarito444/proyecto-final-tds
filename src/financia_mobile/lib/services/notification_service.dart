import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _notificationTitle = 'Recordatorio de Transacciones';
  String _notificationBody = 'Recuerda añadir tus transacciones del día de hoy';
  String _channelName = 'Recordatorio de Transacciones';
  String _channelDescription = 'Recordatorio diario para añadir transacciones';

  void updateLocalizedStrings({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
  }) {
    _notificationTitle = title;
    _notificationBody = body;
    _channelName = channelName;
    _channelDescription = channelDescription;
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();

    // Android 13+ POST_NOTIFICATIONS permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
  }

  Future<void> scheduleDailyTransactionReminder() async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'transaction_reminder',
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    bool canUseExactAlarms = await _canUseExactAlarms();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      _notificationTitle,
      _notificationBody,
      _nextInstanceOf8PM(),
      platformDetails,
      androidScheduleMode: canUseExactAlarms
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact, // fallback si no hay permiso
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'transaction_reminder',
    );
  }

  Future<bool> _canUseExactAlarms() async {
    if (!Platform.isAndroid) return false;

    final int sdkInt = (await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications())?.length ?? 0;

    // Android 12+ requiere permiso SCHEDULE_EXACT_ALARM
    // Android 13+ debe estar habilitado manualmente por el usuario
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true;
    }

    return false; // fallback si no está permitido
  }

  tz.TZDateTime _nextInstanceOf8PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelTransactionReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
