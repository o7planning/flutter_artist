part of '../core.dart';

int __flowLogItemSEQ = 1;

class MasterFlowItem {
  final int id;
  final MasterFlowItemType masterFlowItemType;
  final FuncCallInfo? funcCallInfo;
  final bool isLibCode;
  final TaskType? taskType;
  final DateTime createdDateTime = DateTime.now();

  bool get isDevCode => !isLibCode;

  final Object ownerClassInstance;
  final List<LineFlowItem> __lineFlowItems = [];

  List<LineFlowItem> get lineFlowItems => List.unmodifiable(__lineFlowItems);

  MasterFlowItem._naturalUIEvent({
    required this.ownerClassInstance,
  })  : masterFlowItemType = MasterFlowItemType.naturalUIEvent,
        taskType = null,
        funcCallInfo = null,
        isLibCode = false,
        id = __flowLogItemSEQ++;

  MasterFlowItem._startup({
    required this.ownerClassInstance,
  })  : masterFlowItemType = MasterFlowItemType.startup,
        taskType = null,
        funcCallInfo = null,
        isLibCode = false,
        id = __flowLogItemSEQ++;

  MasterFlowItem._taskCall({
    required this.ownerClassInstance,
    required this.taskType,
  })  : masterFlowItemType = MasterFlowItemType.taskCall,
        funcCallInfo = null,
        isLibCode = false,
        id = __flowLogItemSEQ++;

  MasterFlowItem._methodCallFromStackTrace({
    required this.ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : taskType = null,
        masterFlowItemType = MasterFlowItemType.methodCall,
        funcCallInfo = FuncCallInfo.fromCurrentStackTrace(
          currentStackTrace: currentStackTrace,
          arguments: arguments,
        ),
        id = __flowLogItemSEQ++;

  MasterFlowItem._methodCall({
    required this.ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : taskType = null,
        masterFlowItemType = MasterFlowItemType.methodCall,
        funcCallInfo = FuncCallInfo(funcName: methodName, arguments: arguments),
        id = __flowLogItemSEQ++;

  LineFlowItem _addLineFlowItem({
    LineFlowType? lineFlowType,
    required String codeId,
    required String shortDesc,
    List<String>? extraInfos,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    bool showIconAndLabel = true,
  }) {
    var item = LineFlowItem(
      lineId: codeId,
      lineFlowType: lineFlowType ?? LineFlowType.line,
      showIconAndLabel: showIconAndLabel,
      shortDesc: shortDesc,
      tipDocument: tipDocument,
      errorInfo: errorInfo,
      extraInfos: extraInfos,
    );
    __lineFlowItems.add(item);
    return item;
  }

  bool hasError() {
    return getErrorInfo() != null;
  }

  ErrorInfo? getErrorInfo() {
    for (LineFlowItem item in __lineFlowItems) {
      if (item.errorInfo != null) {
        return item.errorInfo;
      }
    }
    return null;
  }

  bool get isLibPublicMethod {
    return isLibCode && isPublicMethodCall();
  }

  bool get isLibPrivateMethod {
    return isLibCode && isPrivateMethodCall();
  }

  bool isBlock() {
    return ownerClassInstance is Block;
  }

  bool isFilterModel() {
    return ownerClassInstance is FilterModel;
  }

  bool isFormModel() {
    return ownerClassInstance is FormModel;
  }

  bool isOtherClass() {
    return !isBlock() && !isFilterModel() && !isFormModel();
  }

  bool isPrivateMethodCall() {
    return isMethodCall() && funcCallInfo!.isPrivateFunc();
  }

  bool isPublicMethodCall() {
    return isMethodCall() && funcCallInfo!.isPublicFunc();
  }

  bool isMethodCall() {
    return masterFlowItemType == MasterFlowItemType.methodCall;
  }

  bool isTaskCall() {
    return masterFlowItemType == MasterFlowItemType.taskCall;
  }

  bool isMethodCallWithTrace() {
    return funcCallInfo != null && funcCallInfo!.hasTraceInfo();
  }

  Shelf? getShelf() {
    if (ownerClassInstance is Block) {
      return (ownerClassInstance as Block).shelf;
    } else if (ownerClassInstance is FilterModel) {
      return (ownerClassInstance as FilterModel).shelf;
    } else if (ownerClassInstance is FormModel) {
      return (ownerClassInstance as FormModel).block.shelf;
    }
    return null;
  }
}
