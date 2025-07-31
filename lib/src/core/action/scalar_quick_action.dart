import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_quick_action.dart';
import 'base_action.dart';

abstract class ScalarQuickAction extends BaseAction {
  late final ScalarQuickActionConfig config;

  ScalarQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  ScalarQuickActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class ScalarQuickActionConfig {
  final AfterScalarQuickAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const ScalarQuickActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
