part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockMultiItemCreationBackendActionAnnotation()
class _BlockMultiItemCreationBackendActionTaskUnit
    extends _ResultedSTaskUnit<BlockMultiItemCreationBackendActionResult> {
  XBlock xBlock;

  BlockMultiItemCreationBackendAction action;

  _BlockMultiItemCreationBackendActionTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockMultiItemCreationBackendAction,
          taskResult: BlockMultiItemCreationBackendActionResult(),
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
}
