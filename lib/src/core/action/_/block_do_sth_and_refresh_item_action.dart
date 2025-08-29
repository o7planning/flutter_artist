import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../enums/after_silent_action.dart';
import '../_quick_action.dart';

///
/// Do something with an Item and and then refresh it.
/// For Example: Update an Item and then refresh it.
///
// TODO: Hoàn thành logic.
abstract class BlockDoSthAndRefreshItemAction<ITEM> extends QuickAction {
  final ITEM item;

  late final BlockUpdateItemAndRefreshActionConfig config;

  BlockDoSthAndRefreshItemAction({
    required this.item,
    required super.needToConfirm,
    required super.actionInfo,
  }) {
    config = initConfig();
  }

  BlockUpdateItemAndRefreshActionConfig initConfig();

  Future<ApiResult<void>> callApiDoSomething({required ITEM item});
}

class BlockUpdateItemAndRefreshActionConfig {
  final AfterBlockSilentAction afterQuickAction;
  final List<Type> affectedItemTypes;

  const BlockUpdateItemAndRefreshActionConfig({
    required this.affectedItemTypes,
    required this.afterQuickAction,
  });
}
