part of '../core.dart';

abstract class LoginActivity<USER extends ILoggedInUser> extends Activity {
  LoginActivity();

  Future<ApiResult<USER>> performLogin();

  Future<void> navigateToSuccessScreen();

  @override
  Future<void> performExecuteLogic() async {
    ApiResult<USER> result;
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "performExecuteLogic",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#20000",
        shortDesc: "Calling ${debugObjHtml(this)}.performLogin()...",
        lineFlowType: LineFlowType.controllableCalling,
      );
      result = await performLogin();
      // Throw if Error.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: null,
        methodName: "performLogin",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.loginActivityPerformLogin,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#20040",
        shortDesc:
            "The ${debugObjHtml(this)}.performLogin() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    final USER? loggedInUser = result.data;
    if (loggedInUser == null) {
      final message =
          "No data from ${getClassNameWithoutGenerics(this)}.performLogin().";
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#20060",
        shortDesc: "Got value >> @loggedInUser: ${debugObjHtml(loggedInUser)}."
            "\n$message",
      );
      //
      showErrorSnackBar(
        message: message,
        errorDetails: null,
      );
      masterFlowItem._addLineFlowItem(
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
    masterFlowItem._addLineFlowItem(
      codeId: "#20100",
      shortDesc: "Got LoggedInUser: ${debugObjHtml(loggedInUser)}."
          "\n - @accessToken: <b>$tokenPrefix</b>.",
      lineFlowType: LineFlowType.debug,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#20200",
      shortDesc:
          "Calling <b>globalsManager._setOrUpdateLoggedInUserSafely()</b> with parameters:",
      parameters: {
        "loggedInUser": loggedInUser,
        "requiresTheSameUser": false,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    //
    // IMPORTANT:
    // This method never throw an error!
    //
    bool success =
        await FlutterArtist.globalsManager._setOrUpdateLoggedInUserSafely(
      masterFlowItem: masterFlowItem,
      loggedInUser: loggedInUser,
      requiresTheSameUser: false,
    );
    if (!success) {
      masterFlowItem.printToConsole();
      return;
    }
    //
    // After Login with username/password successful.
    // Load Global Data.
    //
    final loginLogoutAdapter = FlutterArtist.globalsManager.loginLogoutAdapter;
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#22060",
        shortDesc:
            "Calling ${debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() with parameters:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      loginLogoutAdapter.addThirdPartyLogicOnLogin(loggedInUser);
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#22080",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() method was called with an error.",
        errorInfo: errorInfo,
      );
      masterFlowItem.printToConsole();
      return;
    }
    //
    // Load Global Data.
    // IMPORTANT: This method never throw an error!
    //
    success = await FlutterArtist.globalsManager._loadGlobalDataSafely(
      masterFlowItem: masterFlowItem,
      loggedInUser: loggedInUser,
    );
    if (!success) {
      masterFlowItem.printToConsole();
      return;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#20400",
      shortDesc: "Calling ${debugObjHtml(this)}.navigateToSuccessScreen()...",
      lineFlowType: LineFlowType.controllableCalling,
    );
    // IMPORTANT: No await:
    navigateToSuccessScreen();
  }
}
