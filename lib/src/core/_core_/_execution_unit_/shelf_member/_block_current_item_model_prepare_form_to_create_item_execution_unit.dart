part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockPrepareFormToCreateItemAnnotation()
class _BlockCurrentItemModelPrepareFormToCreateItemExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XBlockCurrentItemModel xBlockCurrentItemModel;

  @override
  final BlockCurrentItemModelPrepareFormToCreateItemIntent<ID, ITEM,
      ITEM_DETAIL> executionIntent;

  _BlockCurrentItemModelPrepareFormToCreateItemExecutionUnit({
    required this.xBlockCurrentItemModel,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.blockPrepareToCreateItem,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf =>  xBlockCurrentItemModel.xBlock.xShelf;

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
