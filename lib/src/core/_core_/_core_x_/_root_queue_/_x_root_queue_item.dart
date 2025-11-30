part of '../../core.dart';

abstract class XRootQueueItem {
  String get _fullName;

  bool isEmptyTask();

  DebugXRootQueueItem toDebugXRootQueueItem();
}
