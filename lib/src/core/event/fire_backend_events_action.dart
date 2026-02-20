import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '../action/storage_backend_action.dart';
import '../enums/after_backend_action.dart';
import '../typedef/custom_confirmation.dart';

class FireBackendEventsAction extends StorageBackendAction {
  final List<Event> events;

  FireBackendEventsAction({
    required super.needToConfirm,
    String? actionInfo,
    required this.events,
  }) : super(actionInfo: actionInfo ?? "Fire event $events");

  @override
  StorageBackendActionConfig initDefaultConfig() {
    return StorageBackendActionConfig(
      affectedItemTypes: events,
      afterBackendAction: AfterStorageBackendAction.query,
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
