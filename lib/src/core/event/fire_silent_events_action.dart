import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../action/storage_silent_action.dart';
import '../enums/after_silent_action.dart';
import '../typedef/custom_confirmation.dart';

class FireSilentEventsAction extends StorageSilentAction {
  final List<Type> events;

  FireSilentEventsAction({
    required super.needToConfirm,
    String? actionInfo,
    required this.events,
  }) : super(actionInfo: actionInfo ?? "Fire event $events");

  @override
  StorageSilentActionConfig initConfig() {
    return StorageSilentActionConfig(
      affectedItemTypes: events,
      afterQuickAction: AfterStorageSilentAction.query,
    );
  }

  @override
  Future<ApiResult<void>> callApi() async {
    return ApiResult.success();
  }

  @override
  CustomConfirmation? createCustomConfirmation() {
    return null;
  }
}
