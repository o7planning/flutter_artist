import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_quick_action.dart';
import 'base_action.dart';

abstract class BlockQuickAction extends BaseAction {
  late final BlockQuickActionConfig config;

  BlockQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  BlockQuickActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class BlockQuickActionConfig {
  final AfterBlockQuickAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const BlockQuickActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
