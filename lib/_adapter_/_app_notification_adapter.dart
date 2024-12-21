part of '../flutter_artist.dart';

///
///
interface class AppNotificationAdapter {
  Future<ApiResult<BaseNotificationSummary>> callApiGetNotificationSummary() {
    throw UnimplementedError();
  }

  Future<ApiResult<BaseNotification>> callApiGetNotifications() {
    throw UnimplementedError();
  }

  String toJson(BaseNotificationSummary notificationSummary) {
    throw UnimplementedError();
  }

  BaseNotificationSummary? fromJson(String json) {
    throw UnimplementedError();
  }
}
