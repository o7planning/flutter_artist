part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockRefreshCurrentItemAnnotation()
@_BlockSetItemAsCurrentAnnotation()
@_BlockSelectNextItemAsCurrentAnnotation()
@_BlockSelectFirstItemAsCurrentAnnotation()
@_BlockSelectPreviousItemAsCurrentAnnotation()
class _BlockCurrentItemModelSetItemAsCurrentExecutionUnit<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends _ShelfMemberResultedExecutionUnit<
        BlockSetCurrentItemResult<ID, ITEM, ITEM_DETAIL>> {
  final XBlockCurrentItemModel<ID, ITEM, ITEM_DETAIL> xBlockCurrentItemModel;

  @override
  final BlockCurrentItemModelSetCurrentItemIntent<ID, ITEM, ITEM_DETAIL>
      executionIntent;

  _BlockCurrentItemModelSetItemAsCurrentExecutionUnit({
    required this.xBlockCurrentItemModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.blockSetItemAsCurrent,
          executionIntent: executionIntent,
          // executionUnitResult: BlockSetCurrentItemResult<ID,ITEM,ITEM_DETAIL>(
          //   precheck: null,
          //   setCurrentItemDirective: executionIntent.setCurrentItemDirective,
          //   getItemId: xBlock.block._getItemIdInternal,
          //   candidateItem: executionIntent.inputCandidateCurrItem,
          //   oldCurrentItem: xBlock.block.currentItem,
          //   currentItem: xBlock.block.currentItem,
          // ),
        ) {
    xBlockCurrentItemModel.setForceReloadCurrItem(executionIntent.forceReloadItem);
    //
    if (executionIntent.formLoadHint != null) {
       xBlockCurrentItemModel.xBlockFormModel
          ?.setForceType(executionIntent.formLoadHint!);
    }
  }

  @override
  XShelf get xShelf => xBlockCurrentItemModel.xBlock.xShelf;

  @override
  int get xModuleId => xBlockCurrentItemModel.xBlock.xModuleId;

  @override
  Shelf get shelf => xBlockCurrentItemModel.blockCurrentItemModel.shelf;

  @override
  BlockCurrentItemModel get owner => xBlockCurrentItemModel.blockCurrentItemModel;

  @override
  String getObjectName() {
    return xBlockCurrentItemModel.blockCurrentItemModel.name;
  }
}
