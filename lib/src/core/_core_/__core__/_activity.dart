part of '../core.dart';

abstract class Activity extends _Core {
  // TODO: Remove in next version!
  MasterFlowItem? _masterFlowItem;

  late final ui = _ActivityUIComponents(activity: this);

  Activity();

  // ***************************************************************************

  XActivity _createXActivity() {
    return XActivity._(
      activity: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> callApiLogic();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> executeActivity() async {
    _masterFlowItem?._addLineFlowItem(
      codeId: "#23000",
      shortDesc: "Call ${_debugObjHtml(this)}.executeActivity().",
    );
    XActivity xActivity = _createXActivity();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xActivity);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitExecuteActivity({
    required XActivity thisXActivity,
  }) async {
    __assertThisXActivity(thisXActivity);
    //
    _masterFlowItem?._addLineFlowItem(
      codeId: "#19000",
      shortDesc:
          "Begin ${_debugObjHtml(this)} > ${TaskType.activity.asDebugTaskUnit()} task unit.\n"
          "<i>Note: This is called because you called the ${_debugObjHtml(this)}.executeActivity() method.</i>",
    );
    //
    try {
      _masterFlowItem?._addLineFlowItem(
        codeId: "#19100",
        shortDesc: "Calling ${_debugObjHtml(this)}.callApiLogic()...",
      );
      await callApiLogic();
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "callApiLogic",
        // AppError, ApiError or others.
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _masterFlowItem?._addLineFlowItem(
        codeId: "#19200",
        shortDesc:
            "The ${_debugObjHtml(this)}.callApiLogic() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireActivityHidden() {
    // switch (config.hiddenBehavior) {
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
