part of '../core.dart';

@_TaskUnitClassAnnotation()
@_StorageBackendActionAnnotation()
class _StorageBackendActionTaskUnit extends _TaskUnit {
  final StorageBackendAction action;
  final StorageBackendActionResult taskResult = StorageBackendActionResult();

  _StorageBackendActionTaskUnit({
    required this.action,
  }) : super(taskType: TaskType.storageBackendAction);

  @override
  Object get owner => FlutterArtist.storage;

  @override
  String getObjectName() {
    return "StorageBackendAction";
  }
}
