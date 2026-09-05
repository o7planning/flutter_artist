part of '../../core.dart';

sealed class BlockTodo<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>,
        PRECHECK,
        EXECUTION_RESULT extends ExecutionUnitResult<PRECHECK>>
    extends ExecutionTodo<PRECHECK, EXECUTION_RESULT> {
  BlockTodo();
}

final class BlockTodoQuery<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQueryPrecheck,
        BlockQueryResult> {
  final bool isQueryMoreFlow;

  BlockTodoQuery({
    required this.isQueryMoreFlow,
  });
}

final class BlockTodoBackendAction<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockBackendActionPrecheck,
        BlockBackendActionResult> {
  final BlockBackendAction<ID> action;

  BlockTodoBackendAction({required this.action});
}

final class BlockTodoQuickItemUpdate<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQuickItemUpdatePrecheck,
        BlockQuickItemUpdateResult> {
  final BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL> action;

  BlockTodoQuickItemUpdate({required this.action});
}

final class BlockTodoQuickItemCreation<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockQuickItemCreationPrecheck,
        BlockQuickItemCreationResult> {
  final BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL> action;

  BlockTodoQuickItemCreation({required this.action});
}

final class BlockTodoPrepareFormToCreateItem<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemDeletionPrecheck,
        BlockItemDeletionResult<ITEM>> {
  final bool initDirty;
  final FormInput? formInput;

  BlockTodoPrepareFormToCreateItem({
    required this.initDirty,
    required this.formInput,
  });
}

final class BlockTodoDeleteItem<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockItemDeletionPrecheck,
        BlockItemDeletionResult<ITEM>> {
  final ITEM item;

  BlockTodoDeleteItem({
    required this.item,
  });
}

final class BlockTodoClearCurrentItem<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockClearCurrentItemPrecheck,
        BlockClearCurrentItemResult> {
  BlockTodoClearCurrentItem();
}

final class BlockTodoClearItems<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockClearItemsPrecheck,
        BlockClearItemsResult> {
  BlockTodoClearItems();
}

final class BlockTodoSetCurrentItem<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>> //
    extends BlockTodo<
        ID, //
        ITEM,
        ITEM_DETAIL,
        BlockSetCurrentItemPrecheck,
        BlockSetCurrentItemResult<ITEM>> {
  final BlockSetCurrentItemDirective setCurrentItemDirective;
  final List<ITEM> newQueriedList;
  final ITEM? inputCandidateCurrItem;
  final bool forceReloadItem;
  final ForceType? forceTypeForForm;

  BlockTodoSetCurrentItem({
    required this.setCurrentItemDirective,
    required this.newQueriedList,
    required this.inputCandidateCurrItem,
    required this.forceReloadItem,
    required this.forceTypeForForm,
  });
}

final class BlockTodoDone<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockTodo<ID, ITEM, ITEM_DETAIL, dynamic,
        EmptyExecutionUnitResult> {
  final String lastTodoInfo;

  BlockTodoDone({required this.lastTodoInfo});
}

final class BlockTodoNull<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockTodo<ID, ITEM, ITEM_DETAIL, dynamic,
        EmptyExecutionUnitResult> {
  final String lastTodoInfo;

  BlockTodoNull({required this.lastTodoInfo});
}
