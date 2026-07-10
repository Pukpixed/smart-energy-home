class NotificationService {
  Future<void> initialize() async {
    print("Notification Init");
  }

  Future<void> showNotification(String title, String body) async {
    print(title);
    print(body);
  }
}
