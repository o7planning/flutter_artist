import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '../action/storage_backend_action.dart';
import '../typedef/typedefs.dart';

class BroadcastBackendEventsAction extends StorageBackendAction {
  final List<Type> events;

  BroadcastBackendEventsAction({
    required super.needToConfirm,
    String? actionInfo,
    required this.events,
  }) : super(actionInfo: actionInfo ?? "Broadcast events $events");

  @override
  StorageBackendActionConfig defineActionConfig() {
    return StorageBackendActionConfig(
      broadcastEvents: events,
    );
  }

  @override
  Future<ApiResult<void>> performBackendOperation() async {
    return ApiResult.success();
  }

  @override
  CustomConfirmation? createCustomConfirmation() {
    return null;
  }
}
