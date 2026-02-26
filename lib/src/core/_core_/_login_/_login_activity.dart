part of '../core.dart';

abstract class LoginActivity<USER extends ILoggedInUser> extends Activity {
  LoginActivity();

  Future<ApiResult<USER>> performLogin();

  Future<void> navigateToSuccessScreen();

  @override
  Future<void> performActivityOperation() async {
    ApiResult<USER> result;
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "performActivityOperation",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    try {
      executionTrace._addTraceStep(
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
      executionTrace._addTraceStep(
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
      executionTrace._addTraceStep(
        codeId: "#20060",
        shortDesc: "Got value >> @loggedInUser: ${debugObjHtml(loggedInUser)}."
            "\n$message",
      );
      //
      showErrorSnackBar(
        message: message,
        errorDetails: null,
      );
      executionTrace._addTraceStep(
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
    executionTrace._addTraceStep(
      codeId: "#20100",
      shortDesc: "Got LoggedInUser: ${debugObjHtml(loggedInUser)}."
          "\n - @accessToken: <b>$tokenPrefix</b>.",
      lineFlowType: LineFlowType.debug,
    );
    //
    executionTrace._addTraceStep(
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
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
      requiresTheSameUser: false,
    );
    if (!success) {
      executionTrace.printToConsole();
      return;
    }
    //
    // After Login with username/password successful.
    // Load Global Data.
    //
    final loginLogoutAdapter = FlutterArtist.globalsManager.loginLogoutAdapter;
    try {
      executionTrace._addTraceStep(
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
      executionTrace._addTraceStep(
        codeId: "#22080",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() method was called with an error.",
        errorInfo: errorInfo,
      );
      executionTrace.printToConsole();
      return;
    }
    //
    // Load Global Data.
    // IMPORTANT: This method never throw an error!
    //
    success = await FlutterArtist.globalsManager._loadGlobalDataSafely(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
    );
    if (!success) {
      executionTrace.printToConsole();
      return;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#20400",
      shortDesc: "Calling ${debugObjHtml(this)}.navigateToSuccessScreen()...",
      lineFlowType: LineFlowType.controllableCalling,
    );
    // IMPORTANT: No await:
    navigateToSuccessScreen();
  }
}
