import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_action.dart';

abstract class BlockSilentAction extends Action {
  late final BlockSilentActionConfig config;

  BlockSilentAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  BlockSilentActionConfig initConfig();

  Future<ApiResult<void>> callApi();
}

class BlockSilentActionConfig {
  final AfterBlockSilentAction afterSilentAction;
  @Deprecated("Xoa di")
  final List<Type> affectedItemTypes;

  const BlockSilentActionConfig({
    required this.affectedItemTypes,
    required this.afterSilentAction,
  });
}
