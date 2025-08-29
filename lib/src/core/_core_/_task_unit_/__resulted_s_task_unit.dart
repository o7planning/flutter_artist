part of '../core.dart';

@_TaskUnitClassAnnotation()
abstract class _ResultedSTaskUnit<RESULT> extends _STaskUnit {
  final RESULT? taskResult;

  _ResultedSTaskUnit({
    required super.taskType,
    this.taskResult,
  });
}
