part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockClearCurrentItemAnnotation()
class _BlockCurrentItemModelClearCurrentExecutionUnit<
ID extends Comparable, //
ITEM extends Identifiable<ID>,
ITEM_DETAIL extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XBlockCurrentItemModel xBlockCurrentItemModel;

  @override
  final BlockCurrentItemModelClearCurrentItemIntent executionIntent;

  _BlockCurrentItemModelClearCurrentExecutionUnit({
    required this.xBlockCurrentItemModel,
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.blockClearCurrentItem,
    executionIntent: executionIntent,
  );

  @override
  XShelf get xShelf =>xBlockCurrentItemModel. xBlock.xShelf;

  @override
  int get xModuleId =>xBlockCurrentItemModel. xBlock.xModuleId;

  @override
  Shelf get shelf =>xBlockCurrentItemModel. xBlock.block.shelf;

  @override
  BlockCurrentItemModel get owner => xBlockCurrentItemModel.blockCurrentItemModel ;

  @override
  String getObjectName() {
    return xBlockCurrentItemModel.blockCurrentItemModel.name;
  }
}
