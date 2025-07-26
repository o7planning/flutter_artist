part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickUpdateItemActionAnnotation()
class _BlockQuickUpdateItemTaskUnit
    extends _TaskUnit<BlockQuickUpdateItemResult> {
  _XBlock xBlock;
  BlockQuickUpdateItemAction action;

  _BlockQuickUpdateItemTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockQuickUpdateItem,
          result: BlockQuickUpdateItemResult(),
        );

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
}
