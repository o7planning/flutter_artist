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
        lineFlowType: LineFlowType.calling,
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
    final USER? loggedInUser = result.data;
    if (loggedInUser == null) {
      final message =
          "No data from ${getClassNameWithoutGenerics(this)}.callApiLogin().";
      _masterFlowItem?._addLineFlowItem(
        codeId: "#20060",
        shortDesc: "Got value >> @loggedInUser: ${_debugObjHtml(loggedInUser)}."
            "\n$message",
      );
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
    //
    // Right Now, Has not null @loggedInUser.
    //
    String? tokenPrefix = loggedInUser.accessToken;
    if (tokenPrefix != null) {
      tokenPrefix = tokenPrefix.length > 2 //
          ? tokenPrefix.substring(0, 2)
          : tokenPrefix;
      tokenPrefix = "$tokenPrefix...";
    }
    //
    _masterFlowItem?._addLineFlowItem(
      codeId: "#20100",
      shortDesc: "Got LoggedInUser: ${_debugObjHtml(loggedInUser)}."
          "\n - @accessToken: <b>$tokenPrefix</b>.",
      lineFlowType: LineFlowType.debug,
    );
    //
    _masterFlowItem?._addLineFlowItem(
      codeId: "#20200",
      shortDesc:
          "Calling <b>globalsManager._setOrUpdateLoggedInUserSafely()</b> with parameters:"
          "\n - @loggedInUser: ${_debugObjHtml(loggedInUser)}.",
      lineFlowType: LineFlowType.calling,
      isLibCall: true,
    );
    //
    // IMPORTANT:
    // This method never throw an error!
    //
    bool success =
        await FlutterArtist.globalsManager._setOrUpdateLoggedInUserSafely(
      masterFlowItem: _masterFlowItem,
      loggedInUser: loggedInUser,
      requiresTheSameUser: false,
    );
    if (!success) {
      _masterFlowItem?.printToConsole();
      return;
    }
    //
    // After Login with username/password successful.
    // Load Global Data.
    //
    final loginLogoutAdapter = FlutterArtist.globalsManager.loginLogoutAdapter;
    try {
      _masterFlowItem?._addLineFlowItem(
        codeId: "#22060",
        shortDesc:
            "Calling ${_debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() with parameters:"
            "\n - @loggedInUser: ${_debugObjHtml(loggedInUser)}.",
        lineFlowType: LineFlowType.calling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      loginLogoutAdapter.addThirdPartyLogicOnLogin(loggedInUser);
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      _masterFlowItem?._addLineFlowItem(
        codeId: "#22080",
        shortDesc:
            "The ${_debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() method was called with an error.",
        errorInfo: errorInfo,
      );
      _masterFlowItem?.printToConsole();
      return;
    }
    //
    // Load Global Data.
    // IMPORTANT: This method never throw an error!
    //
    success = await FlutterArtist.globalsManager._loadGlobalDataSafely(
      masterFlowItem: _masterFlowItem,
      loggedInUser: loggedInUser,
    );
    if (!success) {
      _masterFlowItem?.printToConsole();
      return;
    }
    //
    _masterFlowItem?._addLineFlowItem(
      codeId: "#20400",
      shortDesc: "Calling ${_debugObjHtml(this)}.navigateToSuccessScreen()...",
      lineFlowType: LineFlowType.calling,
    );
    // IMPORTANT: No await:
    navigateToSuccessScreen();
  }
}
