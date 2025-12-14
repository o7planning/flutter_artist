import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_silent_action.dart';
import '_action.dart';

abstract class BlockSilentAction<ID extends Object, DATA> extends Action {
  late final BlockSilentActionConfig _config;

  BlockSilentActionConfig get config => _config;

  BlockSilentAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    _config = initDefaultConfig();
  }

  BlockSilentActionConfig initDefaultConfig();

  Future<ApiResult<DATA>> callApi();

  ID? extractIdToSetAsCurrent({required DATA data});
}

class BlockSilentActionConfig {
  final AfterBlockSilentAction afterSilentAction;

  // @Deprecated("Xoa di")
  // final List<Type> affectedItemTypes;

  const BlockSilentActionConfig({
    // required this.affectedItemTypes,
    required this.afterSilentAction,
  });
}
