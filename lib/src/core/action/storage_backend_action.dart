import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../_core_/core.dart';
import '_action.dart';

abstract class StorageBackendAction extends Action {
  late final StorageBackendActionConfig config;

  StorageBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initDefaultConfig();
  }

  @protected
  StorageBackendActionConfig initDefaultConfig();

  @protected
  Future<ApiResult<void>> performBackendOperation();
}

class StorageBackendActionConfig {
  final List<Type> emitEvents;

  const StorageBackendActionConfig({
    required this.emitEvents,
  });
}
