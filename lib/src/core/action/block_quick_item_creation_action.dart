part of '__action.dart';

abstract class BlockQuickItemCreationAction<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>> extends Action {
  const BlockQuickItemCreationAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  @override
  @OverridableMethodAnnotation()
  ActionKind get actionKind => ActionKind.creation;

  Future<ApiResult<ITEM_DETAIL>> performQuickCreateItem({
    required Object? parentBlockItem,
  });

  /// Evaluates whether this quick item creation action is allowed to execute
  /// according to application business rules.
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
