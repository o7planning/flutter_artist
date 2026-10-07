part of '../../core.dart';

@_ExecutionUnitClassAnnotation()
@_AppBackendActionAnnotation()
class _AppBackendActionExecutionUnit extends _ExecutionUnit {
  @override
  final AppBackendActionIntent executionIntent;

  _AppBackendActionExecutionUnit({
    required this.executionIntent,
  }) : super(
    executionUnitType: ExecutionUnitType.appBackendAction,
    executionIntent: executionIntent,
  );

  @override
  Object get owner => FlutterArtist.storage;

  @override
  String getObjectName() {
    return "AppBackendAction";
  }
}
