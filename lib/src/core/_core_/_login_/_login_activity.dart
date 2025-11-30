part of '../core.dart';

abstract class LoginActivity<USER extends ILoggedInUser> extends Activity {
  LoginActivity();

  Future<ApiResult<USER>> callApiLogin();

  Future<void> navigateToSuccessScreen();

  @override
  Future<void> callApiLogic() async {
    ApiResult<USER> result;
    try {
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20000",
        shortDesc: "Calling ${_debugObjHtml(this)}.callApiLogin()...",
      );
      result = await callApiLogin();
      // Throw if Error.
      result.throwIfError();
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "callApiLogin",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20040",
        shortDesc:
            "The ${_debugObjHtml(this)}.callApiLogin() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    USER? loggedInUser = result.data;
    if (loggedInUser == null) {
      final message = "No data from ${getClassName(this)}.callApiLogin()";
      //
      showErrorSnackBar(
        message: message,
        errorDetails: null,
      );
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20080",
        shortDesc: message,
      );
      return;
    }
    try {
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20200",
        shortDesc:
            "Calling <b>FlutterArtist._setOrUpdateLoggedInUser()</b> with @loggedInUser: ${_debugObjHtml(loggedInUser)}",
      );
      await FlutterArtist._setOrUpdateLoggedInUser(
        masterFlowItem: _masterFlowItem,
        loggedInUser: loggedInUser,
        requiresTheSameUser: false,
      );
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "FlutterArtist._setOrUpdateLoggedInUser",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20300",
        shortDesc:
            "The <b>FlutterArtist._setOrUpdateLoggedInUser()</b> method was called with and error.",
        errorInfo: errorInfo,
      );
      return;
    }
    _masterFlowItem?._addLineFlowItem(
      codeId: "#20400",
      shortDesc: "Calling ${_debugObjHtml(this)}.navigateToSuccessScreen()...",
    );
    // IMPORTANT: No await:
    navigateToSuccessScreen();
  }
}
