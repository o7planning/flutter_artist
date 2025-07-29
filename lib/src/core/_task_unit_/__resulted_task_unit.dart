part of '../_fa_core.dart';

@_TaskUnitClassAnnotation()
abstract class _ResultedTaskUnit<RESULT> extends _TaskUnit {
  final RESULT? taskResult;

  _ResultedTaskUnit({
    required super.taskType,
    this.taskResult,
  });
}
