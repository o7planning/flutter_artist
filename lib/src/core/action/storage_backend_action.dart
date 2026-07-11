import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_action.dart';

abstract class StorageBackendAction extends Action {
  late final StorageBackendActionConfig config;

  StorageBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = defineActionConfig();
  }

  @protected
  StorageBackendActionConfig defineActionConfig();

  @protected
  Future<ApiResult<void>> performBackendOperation();
}

class StorageBackendActionConfig {
  final List<Type> broadcastEvents;

  const StorageBackendActionConfig({
    required this.broadcastEvents,
  });
}
