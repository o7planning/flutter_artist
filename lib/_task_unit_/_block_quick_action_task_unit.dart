part of '../flutter_artist.dart';

class _BlockQuickActionTaskUnit<DATA extends Object> extends _TaskUnit {
  _XBlock xBlock;
  QuickAction<DATA> action;

  _BlockQuickActionTaskUnit({
    required this.xBlock,
    required this.action,
  });
}
