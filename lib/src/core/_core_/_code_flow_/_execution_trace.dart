part of '../core.dart';

int __flowLogItemSEQ = 1;

class MethodCallExecutionTrace extends ExecutionTrace {
  final FuncCallInfo funcCallInfo;
  final bool isLibMethod;

  bool get isUserMethod => !isLibMethod;

  MethodCallExecutionTrace({
    required super.ownerClassInstance,
    required this.funcCallInfo,
    required this.isLibMethod,
  }) : super(
          executionTraceType: isLibMethod
              ? ExecutionTraceType.libMethodCall
              : ExecutionTraceType.userMethodCall,
        );

  MethodCallExecutionTrace._methodCallFromStackTrace({
    required super.ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
    required this.isLibMethod,
  })  : funcCallInfo = FuncCallInfo.fromCurrentStackTrace(
          currentStackTrace: currentStackTrace,
          arguments: arguments,
        ),
        super(
          executionTraceType: isLibMethod
              ? ExecutionTraceType.libMethodCall
              : ExecutionTraceType.userMethodCall,
        );

  MethodCallExecutionTrace._methodCall({
    required super.ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? arguments,
    required this.isLibMethod,
  })  : funcCallInfo = FuncCallInfo(funcName: methodName, arguments: arguments),
        super(
          executionTraceType: isLibMethod
              ? ExecutionTraceType.libMethodCall
              : ExecutionTraceType.userMethodCall,
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

class NaturalLoadExecutionTrace extends ExecutionTrace {
  NaturalLoadExecutionTrace({
    required super.ownerClassInstance,
  }) : super(executionTraceType: ExecutionTraceType.naturalLoad);

  @override
  String getSubtitle() {
    return "Detect newly displayed UI component";
  }

  @override
  String getTitle() {
    return "Natural Load";
  }
}

class TaskUnitExecutionTrace extends ExecutionTrace {
  final TaskType taskType;

  TaskUnitExecutionTrace({
    required super.ownerClassInstance,
    required this.taskType,
  }) : super(executionTraceType: ExecutionTraceType.taskUnitCall);

  @override
  String getSubtitle() {
    return "${getClassNameWithoutGenerics(ownerClassInstance)} - (${traceSteps.length})";
  }

  @override
  String getTitle() {
    return taskType.name;
  }
}

class StartupExecutionTrace extends ExecutionTrace {
  StartupExecutionTrace({
    required super.ownerClassInstance,
  }) : super(executionTraceType: ExecutionTraceType.startup);

  @override
  String getSubtitle() {
    return "Application start";
  }

  @override
  String getTitle() {
    return "Startup";
  }
}

class QueuedEventExecutionTrace extends ExecutionTrace {
  QueuedEventExecutionTrace({
    required super.ownerClassInstance,
  }) : super(executionTraceType: ExecutionTraceType.queuedEvent);

  @override
  String getSubtitle() {
    return "Processing Queued Events...";
  }

  @override
  String getTitle() {
    return "Queued Events";
  }
}

abstract class ExecutionTrace {
  final int id;
  final ExecutionTraceType executionTraceType;

  final DateTime createdDateTime = DateTime.now();

  final Object ownerClassInstance;
  final List<TraceStep> __traceSteps = [];

  List<TraceStep> get traceSteps => List.unmodifiable(__traceSteps);

  ExecutionTrace({
    required this.ownerClassInstance,
    required this.executionTraceType,
  }) : id = __flowLogItemSEQ++;

  String getTitle();

  String getSubtitle();

  void _addLineFlowSeparator() {
    var item = TraceStep(
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
    __traceSteps.add(item);
  }

  TraceStep _addTraceStep({
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
    var item = TraceStep(
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
    __traceSteps.add(item);
    return item;
  }

  bool hasError() {
    return getErrorInfo() != null;
  }

  bool hasEvent() {
    return getLineFlowEvent() != null;
  }

  TraceStep? getLineFlowEvent() {
    for (TraceStep item in __traceSteps) {
      if (item.lineFlowType == LineFlowType.emitEvent) {
        return item;
      }
    }
    return null;
  }

  ErrorInfo? getErrorInfo() {
    for (TraceStep item in __traceSteps) {
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
    for (TraceStep traceStep in __traceSteps) {
      s += (first ? "" : "\n\n") + traceStep.getText();
      first = false;
    }
    return s;
  }

  void printToConsole() {
    print(getText());
  }
}
