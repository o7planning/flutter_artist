part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_BlockQueryAnnotation()
@_BlockQueryMorePageAnnotation()
@_BlockQueryNextPageAnnotation()
@_BlockQueryPreviousPageAnnotation()
@_BlockQueryAndPrepareToEditAnnotation()
@_BlockQueryAndPrepareToCreateAnnotation()
class _BlockQueryExecutionUnit<
    ID extends Comparable, //
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>> extends _ShelfMemberExecutionUnit {
  final XBlock xBlock;

  @override
  final BlockQueryIntent<ID, ITEM, ITEM_DETAIL> executionIntent;

  _BlockQueryExecutionUnit({
    required this.xBlock,
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.blockQuery,
          executionIntent: executionIntent,
        );

  @override
  XShelf get xShelf => xBlock.xShelf;

  @override
  int get xShelfId => xBlock.xShelfId;

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  Block get owner => xBlock.block;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(xBlock.block)})";
  }
}
