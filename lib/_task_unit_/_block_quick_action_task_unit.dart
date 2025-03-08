part of '../flutter_artist.dart';

class _BlockQuickActionTaskUnit<DATA extends Object> extends _TaskUnit {
  final _XBlock xBlock;
  final QuickAction<DATA> action;
  final AfterBlockQuickAction afterQuickAction;

  _BlockQuickActionTaskUnit({
    required this.xBlock,
    required this.action,
    required this.afterQuickAction,
  });

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
