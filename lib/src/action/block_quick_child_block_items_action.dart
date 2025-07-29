import 'package:flutter_artist_core/flutter_artist_core.dart';

import 'base_action.dart';

abstract class BlockQuickChildBlockItemsAction<
    ITEM extends Object, //
    ITEM_DETAIL extends Object> extends BaseAction {
  final ITEM item;

  const BlockQuickChildBlockItemsAction({
    required this.item,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> callApiChildBlockItems();
}
