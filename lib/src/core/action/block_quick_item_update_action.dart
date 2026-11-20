part of '__action.dart';

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

  @override
  @OverridableMethodAnnotation()
  ActionKind get actionKind => ActionKind.update;

  Future<ApiResult<ITEM_DETAIL>> performQuickUpdateItem({
    required Object? parentBlockItem,
  });

  /// Evaluates whether this quick item update action is allowed to execute
  /// for [item] according to application business rules.
  ///
  /// Receives [parentBlockItem] from the immediate parent block (if any).
  /// Override this method to enforce custom permission or state constraints.
  @OverridableMethodAnnotation()
  bool isAllowed({
    required Object? parentBlockItem,
  }) {
    return true;
  }
}

class BlockQuickItemUpdateActionConfig {
  final bool errorIfItemNotInTheBlock;

  BlockQuickItemUpdateActionConfig({required this.errorIfItemNotInTheBlock});
}
