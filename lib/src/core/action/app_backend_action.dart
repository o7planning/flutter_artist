part of '__action.dart';

abstract class AppBackendAction extends Action {
  late final AppBackendActionConfig config;

  AppBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = defineActionConfig();
  }

  @protected
  AppBackendActionConfig defineActionConfig();

  @protected
  Future<ApiResult<void>> performBackendOperation();
}

class AppBackendActionConfig {
  final List<Type> broadcastEvents;

  const AppBackendActionConfig({
    required this.broadcastEvents,
  });
}
