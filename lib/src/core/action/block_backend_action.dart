import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_backend_action.dart';
import '_action.dart';

abstract class BlockBackendAction<ID extends Object, DATA> extends Action {
  late final BlockBackendActionConfig _config;

  BlockBackendActionConfig get config => _config;

  BlockBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    _config = initDefaultConfig();
  }

  BlockBackendActionConfig initDefaultConfig();

  Future<ApiResult<DATA>> performBackendOperation();

  ID? suggestNewCurrentItemId({required DATA data});
}

class BlockBackendActionConfig {
  final AfterBlockBackendAction afterBackendAction;

  // @Deprecated("Xoa di")
  // final List<Type> affectedItemTypes;

  const BlockBackendActionConfig({
    // required this.affectedItemTypes,
    required this.afterBackendAction,
  });
}
