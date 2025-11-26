part of '../core.dart';

class CodeFlowLogger {
  static const double resetSeconds = 10;

  final List<MasterFlowItem> _masterFlowItems = [];

  List<MasterFlowItem> get masterFlowItems =>
      List.unmodifiable(_masterFlowItems);

  DateTime __lastDateTime = DateTime.now();

  void __markDateTime() {
    DateTime now = DateTime.now();
    Duration duration = now.difference(__lastDateTime);
    if (duration.inSeconds > resetSeconds) {
      clear();
    }
    __lastDateTime = now;
  }

  void clear() {
    _masterFlowItems.clear();
  }

  // ===========================================================================
  // ===========================================================================

  MasterFlowItem _addTaskCall({
    required Object ownerClassInstance,
    required TaskType taskType,
  }) {
    final masterFlowItem = MasterFlowItem._taskCall(
      ownerClassInstance: ownerClassInstance,
      taskType: taskType,
    );
    _masterFlowItems.add(masterFlowItem);
    return masterFlowItem;
  }

  // ===========================================================================
  // ===========================================================================

  void addMethodCall({
    required Object ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? parameters,
  }) {
    __markDateTime();
    //
    MasterFlowItem item;
    try {
      item = MasterFlowItem._methodCallFromStackTrace(
        ownerClassInstance: ownerClassInstance,
        currentStackTrace: currentStackTrace,
        arguments: parameters,
        isLibCode: false,
      );
    } catch (e) {
      item = MasterFlowItem._methodCall(
        ownerClassInstance: ownerClassInstance,
        methodName: "Something Error",
        arguments: parameters,
        isLibCode: false,
      );
    }
    _masterFlowItems.add(item);
  }

  void _addMethodCall({
    required Object ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? navigate,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    MasterFlowItem log = MasterFlowItem._methodCall(
      ownerClassInstance: ownerClassInstance,
      methodName: methodName,
      arguments: parameters,
      isLibCode: isLibCode,
    );
    _masterFlowItems.add(log);
  }
}
