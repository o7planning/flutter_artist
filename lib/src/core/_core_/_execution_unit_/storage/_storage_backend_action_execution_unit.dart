part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_StorageBackendActionAnnotation()
class _StorageBackendActionExecutionUnit extends _ExecutionUnit {
  @override
  final StorageBackendActionIntent executionIntent;

  _StorageBackendActionExecutionUnit({
    required this.executionIntent,
  }) : super(
          executionUnitType: ExecutionUnitType.storageBackendAction,
          executionIntent: executionIntent,
        );

  @override
  Object get owner => FlutterArtist.storage;

  @override
  String getObjectName() {
    return "StorageBackendAction";
  }
}
