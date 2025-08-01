import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../notification/_notification.dart';
import '../notification/_notification_summary.dart';

///
///
interface class INotificationAdapter {
  Future<ApiResult<INotificationSummary>> callApiGetNotificationSummary() {
    throw UnimplementedError();
  }

  Future<ApiResult<INotification>> callApiGetNotifications() {
    throw UnimplementedError();
  }

  String toJson(INotificationSummary notificationSummary) {
    throw UnimplementedError();
  }

  INotificationSummary? fromJson(String json) {
    throw UnimplementedError();
  }
}
