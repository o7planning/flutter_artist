part of '../core.dart';

int __flowLogItemSEQ = 1;

class MethodCallMasterFlowItem extends MasterFlowItem {
  final FuncCallInfo funcCallInfo;
  final bool isLibMethod;

  bool get isUserMethod => !isLibMethod;

  MethodCallMasterFlowItem({
    required super.ownerClassInstance,
    required this.funcCallInfo,
    required this.isLibMethod,
  }) : super(
          masterFlowItemType: isLibMethod
              ? MasterFlowItemType.libMethodCall
              : MasterFlowItemType.userMethodCall,
        );

  MethodCallMasterFlowItem._methodCallFromStackTrace({
    required super.ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
    required this.isLibMethod,
  })  : funcCallInfo = FuncCallInfo.fromCurrentStackTrace(
          currentStackTrace: currentStackTrace,
          arguments: arguments,
        ),
        super(
          masterFlowItemType: isLibMethod
              ? MasterFlowItemType.libMethodCall
              : MasterFlowItemType.userMethodCall,
        );

  MethodCallMasterFlowItem._methodCall({
    required super.ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? arguments,
    required this.isLibMethod,
  })  : funcCallInfo = FuncCallInfo(funcName: methodName, arguments: arguments),
        super(
          masterFlowItemType: isLibMethod
              ? MasterFlowItemType.libMethodCall
              : MasterFlowItemType.userMethodCall,
        );

  @override
  String getSubtitle() {
    return ".${funcCallInfo.funcName}()";
  }

  @override
  String getTitle() {
    return getClassNameWithoutGenerics(ownerClassInstance);
  }

  IconData titleIconData() {
    if (isBlock()) {
      return FaIconConstants.blockIconData;
    } else if (isFilterModel()) {
      return FaIconConstants.filterModelIconData;
    } else if (isFormModel()) {
      return FaIconConstants.formModelIconData;
    } else {
      return FaIconConstants.otherClassIconData;
    }
  }

  Color titleIconColor() {
    if (isLibMethod) {
      // if (isLibPublicMethod) {
      //   return CodeFlowConstants.libPublicCodeIconColor;
      // } else {
      //   return CodeFlowConstants.libPrivateCodeIconColor;
      // }
      return CodeFlowConstants.libPrivateCodeIconColor;
    } else {
      return CodeFlowConstants.devCodeIconColor;
    }
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
    return funcCallInfo.isPrivateFunc();
  }

  bool isPublicMethodCall() {
    return funcCallInfo.isPublicFunc();
  }

  bool isMethodCallWithTrace() {
    return funcCallInfo.hasTraceInfo();
  }
}

class NaturalLoadMasterFlowItem extends MasterFlowItem {
  NaturalLoadMasterFlowItem({
    required super.ownerClassInstance,
  }) : super(masterFlowItemType: MasterFlowItemType.naturalLoad);

  @override
  String getSubtitle() {
    return "Detect newly displayed UI component";
  }

  @override
  String getTitle() {
    return "Natural Load";
  }
}

class TaskUnitMasterFlowItem extends MasterFlowItem {
  final TaskType taskType;

  TaskUnitMasterFlowItem({
    required super.ownerClassInstance,
    required this.taskType,
  }) : super(masterFlowItemType: MasterFlowItemType.taskUnitCall);

  @override
  String getSubtitle() {
    return "${getClassNameWithoutGenerics(ownerClassInstance)} - (${lineFlowItems.length})";
  }

  @override
  String getTitle() {
    return taskType.name;
  }
}

class StartupMasterFlowItem extends MasterFlowItem {
  StartupMasterFlowItem({
    required super.ownerClassInstance,
  }) : super(masterFlowItemType: MasterFlowItemType.startup);

  @override
  String getSubtitle() {
    return "Application start";
  }

  @override
  String getTitle() {
    return "Startup";
  }
}

class QueuedEventMasterFlowItem extends MasterFlowItem {
  QueuedEventMasterFlowItem({
    required super.ownerClassInstance,
  }) : super(masterFlowItemType: MasterFlowItemType.queuedEvent);

  @override
  String getSubtitle() {
    return "Processing Queued Events...";
  }

  @override
  String getTitle() {
    return "Queued Events";
  }
}

abstract class MasterFlowItem {
  final int id;
  final MasterFlowItemType masterFlowItemType;

  final DateTime createdDateTime = DateTime.now();

  final Object ownerClassInstance;
  final List<LineFlowItem> __lineFlowItems = [];

  List<LineFlowItem> get lineFlowItems => List.unmodifiable(__lineFlowItems);

  MasterFlowItem({
    required this.ownerClassInstance,
    required this.masterFlowItemType,
  }) : id = __flowLogItemSEQ++;

  String getTitle();

  String getSubtitle();

  void _addLineFlowSeparator() {
    var item = LineFlowItem(
      lineId: "-----",
      lineFlowType: LineFlowType.separator,
      isLibCall: false,
      showIconAndLabel: false,
      shortDesc: "",
      parameters: null,
      actionable: null,
      note: null,
      tipDocument: null,
      errorInfo: null,
      extraInfos: null,
    );
    __lineFlowItems.add(item);
  }

  LineFlowItem _addLineFlowItem({
    LineFlowType? lineFlowType,
    bool isLibCall = false,
    required String codeId,
    required String shortDesc,
    String? note,
    Map<String, dynamic>? parameters,
    Actionable? actionable,
    List<String>? extraInfos,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    bool showIconAndLabel = true,
  }) {
    var item = LineFlowItem(
      lineId: codeId,
      lineFlowType: lineFlowType ?? LineFlowType.line,
      isLibCall: isLibCall,
      showIconAndLabel: showIconAndLabel,
      shortDesc: shortDesc,
      parameters: parameters,
      actionable: actionable,
      note: note,
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

  bool hasEvent() {
    return getLineFlowEvent() != null;
  }

  LineFlowItem? getLineFlowEvent() {
    for (LineFlowItem item in __lineFlowItems) {
      if (item.lineFlowType == LineFlowType.fireEvent) {
        return item;
      }
    }
    return null;
  }

  ErrorInfo? getErrorInfo() {
    for (LineFlowItem item in __lineFlowItems) {
      if (item.errorInfo != null) {
        return item.errorInfo;
      }
    }
    return null;
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

  String getText() {
    String s = "";
    bool first = true;
    for (LineFlowItem lineFlowItem in __lineFlowItems) {
      s += (first ? "" : "\n\n") + lineFlowItem.getText();
      first = false;
    }
    return s;
  }

  void printToConsole() {
    print(getText());
  }
}
