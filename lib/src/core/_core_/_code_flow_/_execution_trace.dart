part of '../core.dart';

int __flowLogItemSEQ = 1;

// *****************************************************************************
// *****************************************************************************

class NavigationIntentExecutionTrace extends ExecutionTrace {
  final NavigationIntent navigationIntent;

  NavigationIntentExecutionTrace({
    required super.ownerClassInstance,
    required this.navigationIntent,
  }) : super(
          executionTraceType: ExecutionTraceType.navigationIntent,
        );

  @override
  String getSubtitle() {
    return navigationIntent.name;
  }

  @override
  String getTitle() {
    return "Navigation Intent";
  }
}

// *****************************************************************************
// *****************************************************************************

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

// *****************************************************************************
// *****************************************************************************

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

// *****************************************************************************
// *****************************************************************************

class ExecutionUnitExecutionTrace extends ExecutionTrace {
  final ExecutionUnitType executionUnitType;

  ExecutionUnitExecutionTrace({
    required super.ownerClassInstance,
    required this.executionUnitType,
  }) : super(executionTraceType: ExecutionTraceType.executionUnitCall);

  @override
  String getSubtitle() {
    return "${getClassNameWithoutGenerics(ownerClassInstance)} - (${traceSteps.length})";
  }

  @override
  String getTitle() {
    return executionUnitType.name;
  }
}

// *****************************************************************************
// *****************************************************************************

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

// *****************************************************************************
// *****************************************************************************

class EventDispatcherExecutionTrace extends ExecutionTrace {
  final EventSourceType eventSourceType;

  EventDispatcherExecutionTrace({
    required super.ownerClassInstance,
    required this.eventSourceType,
  }) : super(
          executionTraceType: switch (eventSourceType) {
            EventSourceType.internal =>
              ExecutionTraceType.dispatchInternalEvents,
            EventSourceType.special =>
              ExecutionTraceType.dispatchInternalEvents,
            EventSourceType.external =>
              ExecutionTraceType.dispatchExternalEvents,
          },
        );

  @override
  String getSubtitle() {
    switch (eventSourceType) {
      case EventSourceType.special:
        return "Dispatch Special Events...";
      case EventSourceType.internal:
        return "Dispatch Internal Events...";
      case EventSourceType.external:
        return "Dispatch External Events...";
    }
  }

  @override
  String getTitle() {
    switch (eventSourceType) {
      case EventSourceType.special:
        return "EventDispatcher";
      case EventSourceType.internal:
        return "EventDispatcher";
      case EventSourceType.external:
        return "EventDispatcher";
    }
  }
}

// *****************************************************************************
// *****************************************************************************

class ReactionProcessorExecutionTrace extends ExecutionTrace {
  ReactionProcessorExecutionTrace({
    required super.ownerClassInstance,
  }) : super(executionTraceType: ExecutionTraceType.deferredEvent);

  @override
  String getSubtitle() {
    return "Process Reactions...";
  }

  @override
  String getTitle() {
    return "ReactionProcessor";
  }
}

// *****************************************************************************
// *****************************************************************************

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

  // ===========================================================================
  // SPECIALIZED LOGGING FACADE METHODS
  // ===========================================================================

  /// Logs a controllable method call that can be implemented or overridden by developers.
  TraceStep addControllableCall({
    required String codeId,
    required Object caller,
    required String methodName,
    required String suffixShortDesc,
    Map<String, dynamic>? parameters,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    String? note,
  }) {
    final shortDesc =
        "Calling ${debugObjHtml(caller)}.$methodName()... $suffixShortDesc";
    return _addRawStep(
      traceStepType: TraceStepType.controllableCalling,
      codeId: codeId,
      shortDesc: shortDesc,
      parameters: parameters,
      tipDocument: tipDocument,
      errorInfo: errorInfo,
      note: note,
    );
  }

  // ===========================================================================

  /// Logs an internal framework pipeline execution call.
  TraceStep addNonControllableCall({
    required String codeId,
    required Object caller,
    required String methodName,
    required String suffixShortDesc,
    Map<String, dynamic>? parameters,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    String? note,
  }) {
    final shortDesc =
        "Calling ${debugObjHtml(caller)}.$methodName()... $suffixShortDesc";

    return _addRawStep(
      traceStepType: TraceStepType.nonControllableCalling,
      codeId: codeId,
      shortDesc: shortDesc,
      parameters: parameters,
      tipDocument: tipDocument,
      errorInfo: errorInfo,
      note: note,
    );
  }

  // ===========================================================================

  /// Logs the creation and attachment of an execution intent.
  TraceStep addExecutionIntent({
    required String codeId,
    required Object owner,
    required Type executionIntentType,
    required String suffixShortDesc,
    Map<String, dynamic>? parameters,
    String? note,
  }) {
    final shortDesc =
        "Creating ExecutionIntent: ${debugObjHtml(executionIntentType)} for ${debugObjHtml(owner)}. $suffixShortDesc";

    return _addRawStep(
      traceStepType: TraceStepType.executionIntent,
      codeId: codeId,
      shortDesc: shortDesc,
      parameters: parameters,
      note: note,
    );
  }

  // ===========================================================================

  /// Logs an internal or external domain event broadcast/reception.
  TraceStep addBroadcastEvent({
    required String codeId,
    required String shortDesc,
    Map<String, dynamic>? parameters,
    List<String>? extraInfos,
    String? note,
  }) {
    return _addRawStep(
      traceStepType: TraceStepType.broadcastEvent,
      codeId: codeId,
      shortDesc: shortDesc,
      parameters: parameters,
      extraInfos: extraInfos,
      note: note,
    );
  }

  // ===========================================================================

  /// Logs diagnostic metrics, calculations, state transitions, or precheck outputs.
  TraceStep addInfo({
    required String codeId,
    required String shortDesc,
    Map<String, dynamic>? parameters,
    Actionable? actionable,
    BlockSyncDiagnosticSnapshot<Comparable>? snapshot,
    List<String>? extraInfos,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    String? note,
  }) {
    return _addRawStep(
      traceStepType: TraceStepType.info,
      codeId: codeId,
      shortDesc: shortDesc,
      parameters: parameters,
      actionable: actionable,
      snapshot: snapshot,
      extraInfos: extraInfos,
      tipDocument: tipDocument,
      errorInfo: errorInfo,
      note: note,
    );
  }

  // ===========================================================================

  /// Inserts a visual line separator in the execution timeline.
  void addSeparator() {
    _addRawStep(
      traceStepType: TraceStepType.separator,
      codeId: "-----",
      shortDesc: "",
      showIconAndLabel: false,
    );
  }

  // ===========================================================================
  // BASE INTERNAL REGISTRATION
  // ===========================================================================

  TraceStep _addRawStep({
    required TraceStepType traceStepType,
    required String codeId,
    required String shortDesc,
    String? note,
    Map<String, dynamic>? parameters,
    Actionable? actionable,
    BlockSyncDiagnosticSnapshot<Comparable>? snapshot,
    List<String>? extraInfos,
    TipDocument? tipDocument,
    ErrorInfo? errorInfo,
    bool showIconAndLabel = true,
  }) {
    final item = TraceStep(
      lineId: codeId,
      traceStepType: traceStepType,
      showIconAndLabel: showIconAndLabel,
      shortDesc: shortDesc,
      parameters: parameters,
      actionable: actionable,
      blockSyncDiagnosticSnapshot: snapshot,
      note: note,
      tipDocument: tipDocument,
      errorInfo: errorInfo,
      extraInfos: extraInfos,
    );
    __traceSteps.add(item);
    return item;
  }

  // ===========================================================================
  // DEPRECATED COMPATIBILITY ALIASES (FOR SAFE TRANSITION)
  // ===========================================================================

  bool hasError() => getErrorInfo() != null;

  bool hasEvent() => getLineFlowEvent() != null;

  TraceStep? getLineFlowEvent() {
    for (TraceStep item in __traceSteps) {
      if (item.traceStepType == TraceStepType.broadcastEvent) {
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
