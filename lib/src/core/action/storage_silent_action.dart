import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../flutter_artist.dart';

abstract class StorageSilentAction extends Action {
  late final StorageSilentActionConfig config;

  StorageSilentAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initDefaultConfig();
  }

  StorageSilentActionConfig initDefaultConfig();

  Future<ApiResult<void>> callApi();
}

class StorageSilentActionConfig {
  final AfterStorageSilentAction afterQuickAction;
  final List<Event> affectedItemTypes;

  const StorageSilentActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
