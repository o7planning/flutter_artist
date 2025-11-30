part of '../core.dart';

@_TaskUnitClassAnnotation()
@_StorageSilentActionAnnotation()
class _StorageSilentActionTaskUnit extends _TaskUnit {
  final StorageSilentAction action;
  final StorageSilentActionResult taskResult = StorageSilentActionResult();

  _StorageSilentActionTaskUnit({
    required this.action,
  }) : super(taskType: TaskType.storageSilentAction);

  @override
  Object get owner => FlutterArtist.storage;

  @override
  String getObjectName() {
    return "StorageSilentAction";
  }
}
