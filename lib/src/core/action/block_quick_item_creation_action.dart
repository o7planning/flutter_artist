part of '__action.dart';

abstract class BlockQuickItemCreationAction<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends Action {
  const BlockQuickItemCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ITEM_DETAIL>> performQuickCreateItem({
    required Object? parentBlockItem,
  });
}
