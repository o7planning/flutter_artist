part of '../../core.dart';

abstract class XRootQueueItem {
  String get _fullName;

  bool isEmptyExecutionUnit();

  DebugXRootQueueItem toDebugXRootQueueItem();
}
