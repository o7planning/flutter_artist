import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_quick_action.dart';
import '_quick_action.dart';

///
/// Do something and then re-query the Block.
/// For example: Call an API to create or update an item and then re-query the block.
///
// TODO: Hoàn thành logic.
abstract class BlockDoSthAndReQueryAction extends QuickAction {
  late final BlockDoSthAndReQueryActionConfig config;

  BlockDoSthAndReQueryAction({
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  BlockDoSthAndReQueryActionConfig initConfig();

  Future<ApiResult<void>> callApiDoSomething();
}

class BlockDoSthAndReQueryActionConfig {
  final AfterBlockQuickAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const BlockDoSthAndReQueryActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
