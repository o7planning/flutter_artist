import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../action/__action.dart';
import '../typedef/typedefs.dart';

class BroadcastBackendEventsAction extends AppBackendAction {
  final List<Type> events;

  BroadcastBackendEventsAction({
    required super.needToConfirm,
    String? actionInfo,
    required this.events,
  }) : super(actionInfo: actionInfo ?? "Broadcast events $events");

  @override
  AppBackendActionConfig defineActionConfig() {
    return AppBackendActionConfig(
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
