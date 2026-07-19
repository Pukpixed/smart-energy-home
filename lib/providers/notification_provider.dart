import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((e) => !e.isRead).length;

  Future<void> fetchNotifications() async {
    try {
      final snapshot = await _firestore
          .collection("notifications")
          .orderBy("timestamp", descending: true)
          .get();

      _notifications = snapshot.docs
          .map((e) => NotificationModel.fromMap(e.data(), e.id))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _firestore.collection("notifications").doc(id).update({
        "isRead": true,
      });

      fetchNotifications();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addNotification(NotificationModel model) async {
    try {
      await _firestore.collection("notifications").add(model.toMap());

      fetchNotifications();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection("notifications").doc(id).delete();

      fetchNotifications();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
