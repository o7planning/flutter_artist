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
    final masterFlowItem = MasterFlowItem._naturalUIEvent(
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
    final masterFlowItem = MasterFlowItem._startup(
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
    final masterFlowItem = MasterFlowItem._taskCall(
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
    __addMasterFlowItem(item);
  }

  MasterFlowItem _addMethodCall({
    required Object ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? navigate,
    required bool isLibCode,
  }) {
    MasterFlowItem log = MasterFlowItem._methodCall(
      ownerClassInstance: ownerClassInstance,
      methodName: methodName,
      arguments: parameters,
      isLibCode: isLibCode,
    );
    __addMasterFlowItem(log);
    return log;
  }
}
