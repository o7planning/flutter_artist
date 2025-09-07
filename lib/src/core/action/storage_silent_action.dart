import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_action.dart';

abstract class StorageSilentAction extends Action {
  late final StorageSilentActionConfig config;

  StorageSilentAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  StorageSilentActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class StorageSilentActionConfig {
  final AfterStorageSilentAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const StorageSilentActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
