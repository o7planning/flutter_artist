part of '../_fa_core.dart';

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
