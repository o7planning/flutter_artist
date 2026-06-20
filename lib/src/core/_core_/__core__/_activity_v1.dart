part of '../core.dart';

/// An abstract base class that encapsulates non-data-table business logic processes
/// (such as authentication tokens, password recovery pipelines, or generic system workflows).
///
/// ### ⚠️ Design Limitations & Architectural Context
/// Under the current version 1.0.0 implementation, this class offers a very restrictive and
/// basic feature set compared to the robust, data-centric layout features found inside [Shelf].
/// It currently serves as a lightweight, stopgap solution tailored explicitly for driving simple,
/// linear operations like system log-ins or straightforward data submissions.
///
/// ###  Why "ActivityV1" and Future Roadmap
/// This class is intentionally explicitly named **[ActivityV1]** to denote that it represents the
/// first-generation, localized iteration of the business operation subsystem. It is a transitional
/// component and **will be completely replaced or drastically redesigned** in version **2.0.0** /// to offer a comprehensive, full-scale operational workflow engine.
///
/// Appending the "V1" suffix cleanly reserves the premium "Activity" namespace so that the upcoming
/// version 2.0.0 rewrite can introduce the finalized core architecture without imposing chaotic breaking
/// changes on the global naming convention.
abstract class ActivityV1 extends _Core {
  late final ui = _ActivityV1UiComponents(activity: this);

  ActivityV1();

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
      isLibMethod: true,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#23000",
      shortDesc:
      "Creating <b>XActivity</b> for ${debugObjHtml(
          this)} and add it to <b>RootQueue</b>.",
      traceStepType: TraceStepType.info,
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
          "Note: This is called because you called the ${debugObjHtml(
          this)}.executeActivity() method.",
      traceStepType: TraceStepType.debug,
    );
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#19100",
        shortDesc:
        "Calling ${debugObjHtml(this)}.performActivityOperation()...",
        traceStepType: TraceStepType.nonControllableCalling,
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
        "The ${debugObjHtml(
            this)}.performActivityOperation() method was called with an error!",
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
