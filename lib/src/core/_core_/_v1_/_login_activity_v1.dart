part of '../core.dart';

abstract class LoginActivityV1<USER extends ILoggedInUser> extends ActivityV1 {
  LoginActivityV1();

  Future<ApiResult<USER>> performLogin();

  Future<void> navigateToSuccessScreen();

  @override
  Future<void> performActivityOperation() async {
    ApiResult<USER> result;
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "performActivityOperation",
      parameters: null,
      isLibMethod: true,
    );
    try {
      executionTrace.addControllableCall(
        codeId: "#020000",
        caller: this,
        methodName: "performLogin",
        suffixShortDesc: "",
      );
      result = await performLogin();
      // Throw if Error.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        module: null,
        methodName: "performLogin",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.loginActivityPerformLogin,
      );
      executionTrace.addInfo(
        codeId: "#020040",
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
      executionTrace.addInfo(
        codeId: "#020060",
        shortDesc: "Got value >> @loggedInUser: ${debugObjHtml(loggedInUser)}."
            "\n$message",
      );
      //
      showErrorSnackBar(
        message: message,
        errorDetails: null,
      );
      executionTrace.addInfo(
        codeId: "#020080",
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
    executionTrace.addInfo(
      codeId: "#020100",
      shortDesc: "Got LoggedInUser: ${debugObjHtml(loggedInUser)}."
          "\n - @accessToken: <b>$tokenPrefix</b>.",
    );
    //
    executionTrace.addNonControllableCall(
      codeId: "#020200",
      caller: FlutterArtist.globalsManager,
      methodName: "_setOrUpdateLoggedInUserSafely",
      suffixShortDesc: "",
      parameters: {
        "loggedInUser": loggedInUser,
        "requiresTheSameUser": false,
      },
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
      executionTrace.addControllableCall(
        codeId: "#022060",
        caller: loginLogoutAdapter,
        methodName: "addThirdPartyLogicOnLogin",
        suffixShortDesc: "",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      loginLogoutAdapter.addThirdPartyLogicOnLogin(loggedInUser);
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      executionTrace.addInfo(
        codeId: "#022080",
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
    success = await FlutterArtist.globalsManager._performLoadGlobalDataSafely(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
    );
    if (!success) {
      executionTrace.printToConsole();
      return;
    }
    //
    executionTrace.addControllableCall(
      codeId: "#020400",
      caller: this,
      methodName: "navigateToSuccessScreen",
      suffixShortDesc: "",
    );
    // IMPORTANT: No await:
    navigateToSuccessScreen();
  }
}
