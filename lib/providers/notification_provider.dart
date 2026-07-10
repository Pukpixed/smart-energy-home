import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final List<String> notifications = [];

  void addNotification(String message) {
    notifications.add(message);
    notifyListeners();
  }

  void clearNotifications() {
    notifications.clear();
    notifyListeners();
  }
}
