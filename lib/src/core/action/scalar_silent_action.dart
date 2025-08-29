import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_quick_action.dart';

abstract class ScalarSilentAction extends QuickAction {
  late final ScalarSilentActionConfig config;

  ScalarSilentAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  ScalarSilentActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class ScalarSilentActionConfig {
  final AfterScalarSilentAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const ScalarSilentActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
