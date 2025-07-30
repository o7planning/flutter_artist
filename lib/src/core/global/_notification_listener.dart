import '_notification_summary.dart';

interface class INotificationListener {
  void handleNotification(INotificationSummary notificationSummary) {
    throw UnimplementedError();
  }
}
