class NotificationService {
  static List<Map<String, String>> notifications = [];

  static void addNotification(String message) {
    notifications.insert(0, {
      "text": message,
      "time": "Just now"
    });
  }

  static List<Map<String, String>> getNotifications() {
    return notifications;
  }
}