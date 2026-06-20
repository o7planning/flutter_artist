part of '../core.dart';

class GlobalsManager extends _Core {
  int _performLoadGlobalDataCount = 0;

  int get performLoadGlobalDataCount => _performLoadGlobalDataCount;

  IGlobalData? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  IGlobalData? get globalData => _globalData;

  final FlutterArtistLoginLogoutAdapter loginLogoutAdapter;

  final FlutterArtistGlobalDataAdapter globalDataAdapter;

  FaMetadata? _faMetadata;

  final ui = _LoggedInUserUiComponents();
  bool __inited = false;

  GlobalsManager._({
    required this.loginLogoutAdapter,
    required this.globalDataAdapter,
  });

  ///
  /// This method is called only once when FlutterArtist is started.
  ///
  Future<void> _init(ExecutionTrace executionTrace) async {
    if (__inited) return;
    __inited = true;
    executionTrace._addTraceStep(
      codeId: "#GM000",
      shortDesc:
          "Call <b>FaIsarStorage.getLatestMetadata()</b> to read user information that was previously saved locally.",
    );
    _faMetadata = await FaIsarStorage.getLatestMetadata();

    if (_faMetadata == null) {
      print("Stored @faMetadata is NULL");
      executionTrace._addTraceStep(
        codeId: "#GM040",
        shortDesc: "Read @faMetadata: <b>NULL</b>.",
      );
      return;
    }
    executionTrace._addTraceStep(
      codeId: "#GM050",
      shortDesc:
          "Prefer theme: <b>${_faMetadata!.themeName}</b>. Prefer locale: <b>${_faMetadata!.localeCode}</b>",
    );

    print("Read stored themeName: ${_faMetadata!.themeName}");
    FaThemeHub.instance.setThemeByName(_faMetadata!.themeName);

    executionTrace._addTraceStep(
      codeId: "#GM060",
      shortDesc: "Read @userName: <b>${_faMetadata!.userId}</b>.",
    );

    ILoggedInUser? loggedInUser;
    try {
      executionTrace._addTraceStep(
        codeId: "#GM070",
        shortDesc:
            "Calling: <b>${getTypeNameWithoutGenerics(FaIsarStorage)}.getDecryptedUserJson()</b>.",
        parameters: {
          "userId": _faMetadata!.userId,
        },
        traceStepType: TraceStepType.nonControllableCalling,
      );
      final String? loggedInUserJson =
          await FaIsarStorage.getDecryptedUserJson(_faMetadata!.userId);

      if (loggedInUserJson != null) {
        executionTrace._addTraceStep(
          codeId: "#GM080",
          shortDesc: "Calling ${debugObjHtml(loginLogoutAdapter)}.fromJson() "
              "to convert above <b>JSON String</b> to <b>${getTypeNameWithoutGenerics(ILoggedInUser)}</b> object.",
          parameters: {
            "jsonString": loggedInUserJson,
          },
          extraInfos: [loggedInUserJson],
          traceStepType: TraceStepType.controllableCalling,
          tipDocument: TipDocument.loginLogoutAdapter,
        );
        loggedInUser = loginLogoutAdapter.fromJson(loggedInUserJson);
        executionTrace._addTraceStep(
          codeId: "#GM100",
          shortDesc: "Got value: ${debugObjHtml(loggedInUser)}.",
        );
      }
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      executionTrace._addTraceStep(
        codeId: "#GM120",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.fromJson() method was called with an error.",
        note: "You need to log in again via the login page.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    if (loggedInUser == null) {
      executionTrace._addTraceStep(
        codeId: "#GM140",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.fromJson() method returned null.",
        note: "You need to log in again via the login page.",
      );
      return;
    }
    ILoggedInUser refreshedUser;
    try {
      executionTrace._addTraceStep(
        codeId: "#GM160",
        shortDesc:
            "Calling ${debugObjHtml(loginLogoutAdapter)}.performReloadLoggedInUser().",
        traceStepType: TraceStepType.controllableCalling,
        isLibCall: false,
        parameters: {
          "loggedInUser": loggedInUser,
        },
      );
      refreshedUser = await loginLogoutAdapter.performReloadLoggedInUser(
          loggedInUser: loggedInUser);
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      executionTrace._addTraceStep(
        codeId: "#GM180",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.performReloadLoggedInUser() method was called with an error.",
        errorInfo: errorInfo,
      );
      executionTrace.printToConsole();
      return;
    }
    if (refreshedUser.userName != loggedInUser.userName) {
      executionTrace._addTraceStep(
        codeId: "#GM190",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.performReloadLoggedInUser() an invalid user, the username has been changed.",
      );
      executionTrace.printToConsole();
      return;
    }
    // Save again:
    await _setOrUpdateLoggedInUserSafely(
      executionTrace: executionTrace,
      loggedInUser: refreshedUser,
      requiresTheSameUser: true,
    );
    //
    // IMPORTANT: Set before calling globalData.
    // (Do not remove this line).
    //
    _loggedInUser = refreshedUser;
    //
    // After reload User successfully.
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#GM200",
        shortDesc:
            "Calling ${debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() with parameters:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        traceStepType: TraceStepType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      loginLogoutAdapter.addThirdPartyLogicOnLogin(loggedInUser);
    } catch (e, stackTrace) {
      final errorInfo = ErrorInfo.fromError(error: e, stackTrace: stackTrace);
      //
      executionTrace._addTraceStep(
        codeId: "#GM240",
        shortDesc:
            "The ${debugObjHtml(loginLogoutAdapter)}.addThirdPartyLogicOnLogin() method was called with an error.",
        errorInfo: errorInfo,
      );
      executionTrace.printToConsole();
      return;
    }
    //
    // Load Global Data:
    //
    IGlobalData? globalData;
    try {
      _performLoadGlobalDataCount++;
      executionTrace._addTraceStep(
        codeId: "#GM360",
        shortDesc:
            "Calling ${debugObjHtml(loginLogoutAdapter)}.performLoadGlobalData() method with parameters:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        note:
            "This method requires calling an <b>API</b> to retrieve global data for user ${debugObjHtml(loggedInUser)}.",
        traceStepType: TraceStepType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      // Load Global Data:
      globalData = await globalDataAdapter.performLoadGlobalData(
        loggedInUser: loggedInUser,
      );
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      executionTrace._addTraceStep(
        codeId: "#GM420",
        shortDesc:
            "The ${debugObjHtml(globalDataAdapter)}.performLoadGlobalData() method was called with an error.",
        errorInfo: errorInfo,
      );
      executionTrace.printToConsole();
      return;
    }
    _globalData = globalData;
    //
    executionTrace._addTraceStep(
      codeId: "#GM640",
      shortDesc:
          "Reading <b>Extra Global Prop Names</b> from <b>Local</b>. For example: favorite 'locale' and 'theme'.",
      note:
          "This information is stored locally when the user selects a preferred 'locale' or 'theme'.",
      tipDocument: TipDocument.locale,
    );
  }

  Future<void> removeStoredLoggedInUser() async {
    try {
      if (_loggedInUser == null) {
        return;
      }
      await FaIsarStorage.removeUser(_loggedInUser!.userName);
    } catch (e, stackTrace) {
      print("\n\n******** Error removeStoredLoggedInUser: $e ************");
      print(stackTrace);
      return;
    }
  }

  ///
  /// IMPORTANT: This method never throw an error!
  /// Store LoggedInUser data to Local.
  ///
  Future<bool> _setOrUpdateLoggedInUserSafely({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
    required bool requiresTheSameUser,
  }) async {
    if (requiresTheSameUser &&
        _loggedInUser != null &&
        _loggedInUser!.userName != loggedInUser.userName) {
      final errorMessage = "The new and old user must have the same 'userName' "
          "or you must log out before calling this method.";
      final List<String>? errorDetails = null;
      //
      showErrorSnackBar(
        message: errorMessage,
        errorDetails: errorDetails,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#22020",
        shortDesc: errorMessage,
        errorInfo: ErrorInfo(
          errorMessage: errorMessage,
          errorDetails: errorDetails,
          stackTrace: null,
        ),
      );
      return false;
    }
    _loggedInUser = loggedInUser;
    // Store on local device:
    try {
      executionTrace._addTraceStep(
        codeId: "#22420",
        shortDesc: "Calling ${debugObjHtml(loginLogoutAdapter)}.toJson()... "
            "to convert ${debugObjHtml(loggedInUser)} to <b>JSON String</b>.",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        traceStepType: TraceStepType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      String json = loginLogoutAdapter.toJson(loggedInUser);
      //
      executionTrace._addTraceStep(
        codeId: "#22440",
        shortDesc: "Storing the above <b>JSON String</b> to <b>Local</b>.",
        traceStepType: TraceStepType.info,
        extraInfos: [json],
      );
      print("@SAVE userJson --> Call FaIsarStorage.saveSettings()");
      await FaIsarStorage.saveSettings(
          userId: _loggedInUser!.userName, userJson: json);
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
      final warningHtmlMessage =
          "Warning: Unable to store <b>JSON String</b> to <b>Local</b>..\n"
          "This means that the login information cannot be remembered.";
      final appWarning =
          _createAppWarning(HtmlUtils.removeTags(warningHtmlMessage));
      //
      print(appWarning);
      //
      final errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      // This is warning.
      executionTrace._addTraceStep(
        codeId: "#22480",
        shortDesc: warningHtmlMessage,
        errorInfo: errorInfo,
      );
      return true;
    }
    return true;
  }

  ///
  /// IMPORTANT: This method never throw an error!
  ///
  Future<bool> _performLoadGlobalDataSafely({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
  }) async {
    try {
      // Load GlobalData:
      executionTrace._addTraceStep(
        codeId: "#34240",
        shortDesc:
            "Calling ${debugObjHtml(globalDataAdapter)}.performLoadGlobalData() to load global data for @loggedInUser:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        note:
            "You can access global data via <b>FlutterArtist.globalsManager.globalData</b>.",
        traceStepType: TraceStepType.controllableCalling,
        tipDocument: TipDocument.globalData,
      );
      _performLoadGlobalDataCount++;
      IGlobalData globalData = await globalDataAdapter.performLoadGlobalData(
        loggedInUser: loggedInUser,
      );
      _globalData = globalData;
      executionTrace._addTraceStep(
        codeId: "#34280",
        shortDesc: "Got @globalData: ${debugObjHtml(globalData)}",
        traceStepType: TraceStepType.debug,
        tipDocument: TipDocument.globalData,
      );
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      showErrorSnackBar(
        message: errorInfo.errorMessage,
        errorDetails: errorInfo.errorDetails,
      );
      executionTrace._addTraceStep(
        codeId: "#34300",
        shortDesc:
            "The ${debugObjHtml(globalDataAdapter)}.performLoadGlobalData() method called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    try {
      ui.updateAllUiComponents();
    } catch (e, stackTrace) {
      print(stackTrace);
    }
    return true;
  }

  Future<void> _logout() async {
    if (_loggedInUser != null) {
      FaIsarStorage.removeUser(_loggedInUser!.userName);
    }
    _loggedInUser = null;
    _globalData = null;
    ui.updateAllUiComponents();
  }
}
