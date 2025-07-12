part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
@_BlockQuickActionAnnotation()
class _BlockQuickActionTaskUnit<DATA extends Object> extends _TaskUnit {
  final _XBlock xBlock;
  final BlockQuickAction<DATA> action;
  final AfterBlockQuickAction afterQuickAction;

  _BlockQuickActionTaskUnit({
    required this.xBlock,
    required this.action,
    required this.afterQuickAction,
  }) : super(taskType: TaskType.blockQuickAction);

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
