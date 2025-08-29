import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_quick_action.dart';

abstract class StorageSilentAction extends QuickAction {
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
  final AfterScalarSilentAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const StorageSilentActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
