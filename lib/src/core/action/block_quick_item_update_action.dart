import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_action.dart';

abstract class BlockQuickItemUpdateAction<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends Action {
  final BlockQuickItemUpdateActionConfig config;
  final ITEM item;

  const BlockQuickItemUpdateAction({
    required this.item,
    required this.config,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> performQuickUpdateItem({
    required Object? parentBlockItem,
  });
}

class BlockQuickItemUpdateActionConfig {
  final bool errorIfItemNotInTheBlock;

  BlockQuickItemUpdateActionConfig({required this.errorIfItemNotInTheBlock});
}
