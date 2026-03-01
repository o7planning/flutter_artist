part of '../core.dart';

abstract class Activity extends _Core {
  late final ui = _ActivityUiComponents(activity: this);

  Activity();

  // ***************************************************************************

  XActivity _createXActivity() {
    return XActivity._(
      activity: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @protected
  Future<void> performActivityOperation();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> executeActivity() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeActivity",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#23000",
      shortDesc:
          "Creating <b>XActivity</b> for ${debugObjHtml(this)} and add it to <b>RootQueue</b>.",
      lineFlowType: LineFlowType.info,
    );
    XActivity xActivity = _createXActivity();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitExecuteActivity({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XActivity thisXActivity,
  }) async {
    __assertThisXActivity(thisXActivity);
    //
    executionTrace._addTraceStep(
      codeId: "#19000",
      shortDesc:
          "Begin ${debugObjHtml(this)} > ${taskType.asDebugTaskUnit()}.\n"
          "Note: This is called because you called the ${debugObjHtml(this)}.executeActivity() method.",
      lineFlowType: LineFlowType.debug,
    );
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#19100",
        shortDesc:
            "Calling ${debugObjHtml(this)}.performActivityOperation()...",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      await performActivityOperation();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "performActivityOperation",
        // AppError, ApiError or others.
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.activity,
      );
      executionTrace._addTraceStep(
        codeId: "#19200",
        shortDesc:
            "The ${debugObjHtml(this)}.performActivityOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _emitActivityHidden() {
    // switch (config.onHideAction) {
    //   case ActivityHiddenBehavior.none:
    //     break;
    //   case ActivityHiddenBehavior.clear:
    //   // TODO: Handle this case.
    //   //  throw UnimplementedError();
    // }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXActivity(XActivity thisXActivity) {
    if (thisXActivity.activity != this) {
      String message =
          "Error Assert activity: ${thisXActivity.activity} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
