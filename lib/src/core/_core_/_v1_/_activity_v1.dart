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

  XActivityV1 _createXActivity() {
    return XActivityV1._(
      activityV1: this,
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
    executionTrace.addInfo(
      codeId: "#23000",
      shortDesc:
      "Creating <b>XActivity</b> for ${debugObjHtml(
          this)} and add it to <b>RootQueue</b>.",
    );
    XActivityV1 xActivity = _createXActivity();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeExecutionUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitExecuteActivity({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XActivityV1 thisXActivity,
    required DefaultActivityV1ExecutionIntent executionIntent,
  }) async {
    __assertThisXActivity(thisXActivity);
    //
    executionTrace.addInfo(
      codeId: "#19000",
      shortDesc:
      "Begin ${debugObjHtml(this)} > ${executionUnitType
          .asDebugExecutionUnit()}.\n"
          "Note: This is called because you called the ${debugObjHtml(
          this)}.executeActivity() method.",
    );
    final activityResult = executionIntent.resultWrapper._setResult(
      ActivityResult(),
      objectCaller: this,
      methodName: '_unitExecuteActivity',
    );
    //
    try {
      executionTrace.addNonControllableCall(
        codeId: "#19100",
        caller: this,
        methodName: "performActivityOperation",
        suffixShortDesc: "",
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
      activityResult._setErrorInfo(errorInfo: errorInfo);
      executionTrace.addInfo(
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

  void _broadcastActivityHidden() {
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

  void __assertThisXActivity(XActivityV1 thisXActivity) {
    if (thisXActivity.activityV1 != this) {
      String message =
          "Error Assert activity: ${thisXActivity.activityV1} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
