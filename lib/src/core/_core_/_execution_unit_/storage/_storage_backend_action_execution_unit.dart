part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_StorageBackendActionAnnotation()
class _StorageBackendActionExecutionUnit extends _ExecutionUnit {
  final StorageBackendAction action;
  final StorageBackendActionResult executionUnitResult = StorageBackendActionResult();

  _StorageBackendActionExecutionUnit({
    required this.action,
  }) : super(
          executionUnitType: ExecutionUnitType.storageBackendAction,
        );

  @override
  Object get owner => FlutterArtist.storage;

  @override
  String getObjectName() {
    return "StorageBackendAction";
  }
}
