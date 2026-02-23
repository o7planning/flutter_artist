part of '../core.dart';

@_TaskUnitClassAnnotation()
@_BlockBackendActionAnnotation()
class _BlockBackendActionTaskUnit
    extends _ResultedSTaskUnit<BlockBackendActionResult> {
  final XBlock xBlock;
  final BlockBackendAction action;

  _BlockBackendActionTaskUnit({
    required this.xBlock,
    required this.action,
  }) : super(
          taskType: TaskType.blockBackendAction,
          taskResult: BlockBackendActionResult(),
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
