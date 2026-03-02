part of '../core.dart';

class CodeFlowLogger {
  final int codeFlowRetentionPeriodInSeconds;

  final List<ExecutionTrace> _executionTraces = [];

  List<ExecutionTrace> get executionTraces =>
      List.unmodifiable(_executionTraces);

  CodeFlowLogger({required this.codeFlowRetentionPeriodInSeconds});

  void clear() {
    _executionTraces.clear();
  }

  // ===========================================================================
  // ===========================================================================

  void __addExecutionTrace(ExecutionTrace executionTrace) {
    _executionTraces.removeWhere((item) {
      DateTime now = DateTime.now();
      Duration duration = now.difference(item.createdDateTime);
      if (duration.inSeconds > codeFlowRetentionPeriodInSeconds) {
        return true;
      }
      return false;
    });
    _executionTraces.add(executionTrace);
  }

  // ===========================================================================
  // ===========================================================================

  ExecutionTrace _addNaturalUIEvent({
    required Object ownerClassInstance,
  }) {
    final executionTrace = NaturalLoadExecutionTrace(
      ownerClassInstance: ownerClassInstance,
    );
    __addExecutionTrace(executionTrace);
    return executionTrace;
  }

  // ===========================================================================
  // ===========================================================================

  ExecutionTrace _addStartup({
    required Object ownerClassInstance,
  }) {
    final executionTrace = StartupExecutionTrace(
      ownerClassInstance: ownerClassInstance,
    );
    __addExecutionTrace(executionTrace);
    return executionTrace;
  }

  // ===========================================================================
  // ===========================================================================

  ExecutionTrace _addTaskCall({
    required Object ownerClassInstance,
    required TaskType taskType,
  }) {
    final executionTrace = TaskUnitExecutionTrace(
      ownerClassInstance: ownerClassInstance,
      taskType: taskType,
    );
    __addExecutionTrace(executionTrace);
    return executionTrace;
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
    ExecutionTrace item;
    try {
      item = MethodCallExecutionTrace._methodCallFromStackTrace(
        ownerClassInstance: ownerClassInstance,
        currentStackTrace: currentStackTrace,
        arguments: parameters,
        isLibMethod: false,
      );
    } catch (e) {
      item = MethodCallExecutionTrace._methodCall(
        ownerClassInstance: ownerClassInstance,
        methodName: "Something Error",
        arguments: parameters,
        isLibMethod: false,
      );
    }
    __addExecutionTrace(item);
  }

  ExecutionTrace _addMethodCall({
    required Object ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? navigate,
    required bool isLibMethod,
  }) {
    ExecutionTrace log = MethodCallExecutionTrace._methodCall(
      ownerClassInstance: ownerClassInstance,
      methodName: methodName,
      arguments: parameters,
      isLibMethod: isLibMethod,
    );
    __addExecutionTrace(log);
    return log;
  }

  ExecutionTrace _initTaskUnitForDeferredEvent({
    required Object ownerClassInstance,
  }) {
    ExecutionTrace log = DeferredEventExecutionTrace(
      ownerClassInstance: ownerClassInstance,
    );
    __addExecutionTrace(log);
    return log;
  }
}
