import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import 'supabase_service.dart';

class NotificationService {

  static List<AppNotification> notifications = [];

  static ValueNotifier<int> notifier = ValueNotifier(0);

  static Future<void> initialize() async {

    /// Initialize OneSignal
    OneSignal.initialize("aa01c747-8734-4484-b8a0-39fbbbac3adb");

    /// Request permission
    await OneSignal.Notifications.requestPermission(true);

    /// Debug: show player id
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint("Player ID: ${state.current.id}");
    });

    /// Load local notifications
    await loadNotifications();

    /// Sync with Supabase
    await syncFromServer();

    /// Foreground notification listener
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {

      final id = event.notification.notificationId;
      final title = event.notification.title;
      final body = event.notification.body;

      bool exists = notifications.any((n) => n.id == id);

      if (!exists) {
        saveNewNotification(id, title, body);
      }

    });

    /// Click listener
    OneSignal.Notifications.addClickListener((event) {

      final id = event.notification.notificationId;
      final title = event.notification.title;
      final body = event.notification.body;

      bool exists = notifications.any((n) => n.id == id);

      if (!exists) {
        saveNewNotification(id, title, body);
      }

    });

  }

  /// Sync notifications from Supabase
  static Future<void> syncFromServer() async {

    try {

      List<AppNotification> serverData =
          await SupabaseService.fetchNotifications();

      for (var n in serverData) {

        bool exists = notifications.any((e) => e.id == n.id);

        if (!exists) {
          notifications.add(n);
        }

      }

      notifier.value++;

    } catch (e) {

      debugPrint("Supabase sync error: $e");

    }

  }

  /// Save new notification
  static Future<void> saveNewNotification(
      String id, String? title, String? body) async {

    AppNotification newNotification = AppNotification(
      id: id,
      title: title ?? "",
      body: body ?? "",
      time: DateTime.now(),
    );

    notifications.insert(0, newNotification);

    await saveNotifications();

    notifier.value++;

  }

  /// Save locally
  static Future<void> saveNotifications() async {

    final prefs = await SharedPreferences.getInstance();

    List<String> data =
        notifications.map((n) => jsonEncode(n.toJson())).toList();

    await prefs.setStringList("notifications", data);

  }

  /// Load local notifications
  static Future<void> loadNotifications() async {

    final prefs = await SharedPreferences.getInstance();

    List<String>? data = prefs.getStringList("notifications");

    if (data != null) {

      notifications =
          data.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();

      notifier.value++;

    }

  }

}