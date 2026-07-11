import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/_block_viewport_sync_strategy.dart';
import '_action.dart';

abstract class BlockBackendAction<ID extends Object> extends Action {
  late final BlockBackendActionConfig _config;

  BlockBackendActionConfig get config => _config;

  BlockBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    _config = defineActionConfig();
  }

  BlockBackendActionConfig defineActionConfig();

  Future<ApiResult<ListData<ID>?>> performBackendOperation({
    required Object? parentBlockItem,
  });

  ID? suggestNewCurrentItemId({required List<ID> itemIds});
}

class BlockBackendActionConfig {
  final BlockViewportSyncStrategy? viewportSyncStrategy;
  final List<Type>? broadcastEvents;

  const BlockBackendActionConfig({
    required this.viewportSyncStrategy,
    this.broadcastEvents,
  });
}
