part of '../core.dart';

class CodeFlowLogger {
  static const double resetSeconds = 10;

  final List<MasterFlowItem> _masterFlowItems = [];

  List<MasterFlowItem> get masterFlowItems =>
      List.unmodifiable(_masterFlowItems);

  void clear() {
    _masterFlowItems.clear();
  }

  // ===========================================================================
  // ===========================================================================

  void __addMasterFlowItem(MasterFlowItem masterFlowItem) {
    _masterFlowItems.removeWhere((item) {
      DateTime now = DateTime.now();
      Duration duration = now.difference(item.createdDateTime);
      if (duration.inSeconds > resetSeconds) {
        return true;
      }
      return false;
    });
    _masterFlowItems.add(masterFlowItem);
  }

  // ===========================================================================
  // ===========================================================================

  MasterFlowItem _addNaturalUIEvent({
    required Object ownerClassInstance,
  }) {
    final masterFlowItem = NaturalLoadMasterFlowItem(
      ownerClassInstance: ownerClassInstance,
    );
    __addMasterFlowItem(masterFlowItem);
    return masterFlowItem;
  }

  // ===========================================================================
  // ===========================================================================

  MasterFlowItem _addStartup({
    required Object ownerClassInstance,
  }) {
    final masterFlowItem = StartupMasterFlowItem(
      ownerClassInstance: ownerClassInstance,
    );
    __addMasterFlowItem(masterFlowItem);
    return masterFlowItem;
  }

  // ===========================================================================
  // ===========================================================================

  MasterFlowItem _addTaskCall({
    required Object ownerClassInstance,
    required TaskType taskType,
  }) {
    final masterFlowItem = TaskUnitMasterFlowItem(
      ownerClassInstance: ownerClassInstance,
      taskType: taskType,
    );
    __addMasterFlowItem(masterFlowItem);
    return masterFlowItem;
  }

  // ===========================================================================
  // ===========================================================================

  void addMethodCall({
    required Object ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? parameters,
  }) {
    if (FlutterArtist.executor.isBusy) {
      // return;
    }
    if (FlutterArtist._lockAddMoreQuery) {
      return;
    }
    //
    MasterFlowItem item;
    try {
      item = MethodCallMasterFlowItem._methodCallFromStackTrace(
        ownerClassInstance: ownerClassInstance,
        currentStackTrace: currentStackTrace,
        arguments: parameters,
        isLibMethod: false,
      );
    } catch (e) {
      item = MethodCallMasterFlowItem._methodCall(
        ownerClassInstance: ownerClassInstance,
        methodName: "Something Error",
        arguments: parameters,
        isLibMethod: false,
      );
    }
    __addMasterFlowItem(item);
  }

  MasterFlowItem _addMethodCall({
    required Object ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? navigate,
    required bool isLibMethod,
  }) {
    MasterFlowItem log = MethodCallMasterFlowItem._methodCall(
      ownerClassInstance: ownerClassInstance,
      methodName: methodName,
      arguments: parameters,
      isLibMethod: isLibMethod,
    );
    __addMasterFlowItem(log);
    return log;
  }

  MasterFlowItem _initTaskUnitForQueuedEvent({
    required Object ownerClassInstance,
  }) {
    MasterFlowItem log = QueuedEventMasterFlowItem(
      ownerClassInstance: ownerClassInstance,
    );
    __addMasterFlowItem(log);
    return log;
  }
}
