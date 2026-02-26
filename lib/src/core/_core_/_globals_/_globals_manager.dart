part of '../core.dart';

class GlobalsManager extends _Core {
  final String __separator = ";";

  ///
  /// Hive Prefix Key for "Extra Prop Names", for example: {'language', 'theme'}.
  ///
  final String __prefixHiveExtraPropNamesKey = "--hive-extra-prop-names-key--";

  ///
  /// Hive Prefix Key for "Extra Prop Name", for example: 'language'.
  ///
  final String __prefixHiveExtraPropNameKey = "--hive-extra-prop-name-key--";

  //
  final String __hiveKeyLoggedInUser =
      "*---flutter-artist-hive-key-logged-in-user---*";

  int _loadGlobalDataCount = 0;

  int get loadGlobalDataCount => _loadGlobalDataCount;

  IGlobalData? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  IGlobalData? get globalData => _globalData;

  final ILoginLogoutAdapter loginLogoutAdapter;

  final IGlobalDataAdapter globalDataAdapter;

  ///
  /// For example: {"language", "theme"}
  ///
  final Set<String> __registeredExtraPropNames = {};

  Set<String> get registeredExtraPropNames => {...__registeredExtraPropNames};

  final Map<String, dynamic> __extraPropMap = {};

  final ui = _LoggedInUserUiComponents();

  GlobalsManager._({
    required this.loginLogoutAdapter,
    required this.globalDataAdapter,
  });

  String __getHiveExtraGlobalPropNamesKey(ILoggedInUser loggedInUser) {
    return "$__prefixHiveExtraPropNamesKey-**-${loggedInUser.userName}";
  }

  String __getHiveExtraGlobalPropNameKey({
    required ILoggedInUser loggedInUser,
    required String propName,
  }) {
    return "$__prefixHiveExtraPropNameKey-**-$propName-**-${loggedInUser.userName}";
  }

  ///
  /// Extra Global Prop Names. For Example:
  /// - language
  /// - theme
  ///
  Future<void> __readExtraGlobalProps({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
  }) async {
    executionTrace._addTraceStep(
      codeId: "#E0000",
      shortDesc:
          "Open <b>HiveBox</b> to read <b>Extra Global Prop Names</b> from <b>Local</b>.",
    );
    // Store on local device:
    Box<String> hiveBox = await HiveUtils.openHiveBoxExtraGlobalPropNames();
    try {
      // xxx-**-${loggedInUser.userName}
      String key = __getHiveExtraGlobalPropNamesKey(loggedInUser);
      String extraGlobalPropNamesStr = hiveBox.get(key) ?? "";
      //
      executionTrace._addTraceStep(
        codeId: "#E0100",
        shortDesc: "Result from <b>HiveBox</b>:",
        parameters: {
          "key": key,
          "extraGlobalPropNamesStr": extraGlobalPropNamesStr,
        },
        lineFlowType: LineFlowType.debug,
      );
      List<String> extraGlobalPropNames = extraGlobalPropNamesStr
          .split(__separator)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      executionTrace._addTraceStep(
        codeId: "#E0200",
        shortDesc: " - @extraGlobalPropNames: <b>$extraGlobalPropNames</b>.",
      );
      //
      __registeredExtraPropNames
        ..clear()
        ..addAll(extraGlobalPropNames);
    } catch (e, stackTrace) {
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      executionTrace._addTraceStep(
        codeId: "#E0300",
        shortDesc: "Has an error.",
        errorInfo: errorInfo,
      );
      return;
    } finally {
      await hiveBox.close();
    }
    //
    for (String propName in __registeredExtraPropNames) {
      executionTrace._addTraceStep(
        codeId: "#E0400",
        shortDesc: "Reading prop <b>'$propName'</b> from <b>HiveBox</b>...",
      );
      dynamic value = await __readExtraGlobalProp(
        loggedInUser: loggedInUser,
        propName: propName,
      );
      __extraPropMap[propName] = value;
      executionTrace._addTraceStep(
        codeId: "#E0500",
        shortDesc: "Result from <b>HiveBox</b>:"
            "\n - @propName: <b>$propName</b>"
            "\n - @value: <b>$value</b>",
        note:
            "You can access current locale via <b>FlutterArtist.localeManager.currentLocale</b>.",
        tipDocument: TipDocument.locale,
      );
    }
  }

  Future<bool> __storeExtraGlobalPropNames({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
  }) async {
    // Store on local device:
    Box<String> hiveBox = await HiveUtils.openHiveBoxExtraGlobalPropNames();
    String key = __getHiveExtraGlobalPropNamesKey(loggedInUser);
    try {
      String value = __registeredExtraPropNames.toList().join(__separator);

      executionTrace._addTraceStep(
        codeId: "#LE000",
        shortDesc: "Store to the <b>HiveBox</b>:",
        parameters: {
          "key": key,
          "value": value,
        },
        lineFlowType: LineFlowType.debug,
      );
      await hiveBox.put(key, value);
      return true;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      executionTrace._addTraceStep(
        codeId: "#LE020",
        shortDesc: "Store @key: <b>$key</b> error!",
        errorInfo: errorInfo,
      );
      return false;
    } finally {
      await hiveBox.close();
    }
  }

  Future<dynamic> __readExtraGlobalProp({
    required ILoggedInUser loggedInUser,
    required String propName,
  }) async {
    Box<dynamic> hiveBox = await HiveUtils.openHiveBoxExtraGlobalProp();
    try {
      String key = __getHiveExtraGlobalPropNameKey(
        loggedInUser: loggedInUser,
        propName: propName,
      );
      dynamic value = hiveBox.get(key);
      return value;
    } finally {
      await hiveBox.close();
    }
  }

  dynamic getExtraGlobalProp(String propName) {
    return __extraPropMap[propName];
  }

  Future<void> _storeExtraGlobalProp({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
    required String propName,
    required dynamic value,
  }) async {
    __registeredExtraPropNames.add(propName);
    executionTrace._addTraceStep(
      codeId: "#LS000",
      shortDesc:
          "Registered extraPropNames: <b>${__registeredExtraPropNames.toList()}</b>.",
      lineFlowType: LineFlowType.debug,
    );
    bool success = await __storeExtraGlobalPropNames(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
    );
    if (!success) {
      return;
    }
    //
    __extraPropMap[propName] = value;
    //
    Box<dynamic> hiveBox = await HiveUtils.openHiveBoxExtraGlobalProp();
    // xxx*$propName*userName
    String key = __getHiveExtraGlobalPropNameKey(
      loggedInUser: loggedInUser,
      propName: propName,
    );
    executionTrace._addTraceStep(
      codeId: "#LS100",
      shortDesc: "Store to the <b>HiveBox</b>:"
          "\n - @key: <b>$key</b>"
          "\n - @value: <b>$value</b>",
      lineFlowType: LineFlowType.debug,
    );
    await hiveBox.put(key, value);
    await hiveBox.close();
  }

  ///
  /// This method is called only once when FlutterArtist is started.
  ///
  Future<void> _init(ExecutionTrace executionTrace) async {
    executionTrace._addTraceStep(
      codeId: "#GM000",
      shortDesc:
          "Open <b>HiveBox</b> to read user information that was previously saved locally.",
    );
    Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
    executionTrace._addTraceStep(
      codeId: "#GM020",
      shortDesc:
          "Reading <b>LoggedInUser JSON String</b> from <b>HiveBox</b>...",
      parameters: {
        "key": __hiveKeyLoggedInUser,
      },
      note:
          "This information has been stored locally when the user successfully logged in before.",
    );
    String? loggedInUserJson = hiveBox.get(__hiveKeyLoggedInUser);
    await hiveBox.close();

    if (loggedInUserJson == null) {
      executionTrace._addTraceStep(
        codeId: "#GM040",
        shortDesc: "Read @loggedInUserJson: <b>NULL</b>.",
        parameters: {
          "key": __hiveKeyLoggedInUser,
        },
      );
      return;
    }
    executionTrace._addTraceStep(
      codeId: "#GM060",
      shortDesc: "Read @loggedInUserJson: <b>NOT NULL</b>.",
      parameters: {
        "key": __hiveKeyLoggedInUser,
      },
      extraInfos: [loggedInUserJson],
    );
    ILoggedInUser? loggedInUser;
    try {
      executionTrace._addTraceStep(
        codeId: "#GM080",
        shortDesc: "Calling ${debugObjHtml(loginLogoutAdapter)}.fromJson() "
            "to convert above <b>JSON String</b> to <b>${getTypeNameWithoutGenerics(ILoggedInUser)}</b> object.",
        parameters: {
          "jsonString": loggedInUserJson,
        },
        extraInfos: [loggedInUserJson],
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      loggedInUser = loginLogoutAdapter.fromJson(loggedInUserJson);
      executionTrace._addTraceStep(
        codeId: "#GM100",
        shortDesc: "Got value: ${debugObjHtml(loggedInUser)}.",
      );
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
    //
    // IMPORTANT: Set before calling globalData.
    // (Do not remove this line).
    //
    _loggedInUser = loggedInUser;
    //
    // After load User from Local successfully.
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#GM160",
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
      _loadGlobalDataCount++;
      executionTrace._addTraceStep(
        codeId: "#GM360",
        shortDesc:
            "Calling ${debugObjHtml(loginLogoutAdapter)}.loadGlobalData() method with parameters:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        note:
            "This method requires calling an <b>API</b> to retrieve global data for user ${debugObjHtml(loggedInUser)}.",
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      // Load Global Data:
      globalData = await globalDataAdapter.loadGlobalData(
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
            "The ${debugObjHtml(loginLogoutAdapter)}.loadGlobalData() method was called with an error.",
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
    // Load Extra Global Prop Names that stored in Hive Database.
    await __readExtraGlobalProps(
      executionTrace: executionTrace,
      loggedInUser: loggedInUser,
    );
  }

  Future<void> removeStoredLoggedInUser() async {
    try {
      Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
      hiveBox.delete(__hiveKeyLoggedInUser);
      await hiveBox.close();
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
    Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
    try {
      executionTrace._addTraceStep(
        codeId: "#22420",
        shortDesc: "Calling ${debugObjHtml(loginLogoutAdapter)}.toJson()... "
            "to convert ${debugObjHtml(loggedInUser)} to <b>JSON String</b>.",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.loginLogoutAdapter,
      );
      String json = loginLogoutAdapter.toJson(loggedInUser);
      //
      executionTrace._addTraceStep(
        codeId: "#22440",
        shortDesc: "Storing the above <b>JSON String</b> to <b>Local</b>.",
        parameters: {
          "key": __hiveKeyLoggedInUser,
        },
        lineFlowType: LineFlowType.info,
        extraInfos: [json],
      );
      await hiveBox.put(__hiveKeyLoggedInUser, json);
      await hiveBox.flush();
      await hiveBox.close();
    } catch (e, stackTrace) {
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
  Future<bool> _loadGlobalDataSafely({
    required ExecutionTrace executionTrace,
    required ILoggedInUser loggedInUser,
  }) async {
    try {
      // Load GlobalData:
      executionTrace._addTraceStep(
        codeId: "#34240",
        shortDesc:
            "Calling ${debugObjHtml(globalDataAdapter)}.loadGlobalData() to load global data for @loggedInUser:",
        parameters: {
          "loggedInUser": loggedInUser,
        },
        note:
            "You can access global data via <b>FlutterArtist.globalsManager.globalData</b>.",
        lineFlowType: LineFlowType.controllableCalling,
        tipDocument: TipDocument.globalData,
      );
      _loadGlobalDataCount++;
      IGlobalData globalData = await globalDataAdapter.loadGlobalData(
        loggedInUser: loggedInUser,
      );
      _globalData = globalData;
      executionTrace._addTraceStep(
        codeId: "#34280",
        shortDesc: "Got @globalData: ${debugObjHtml(globalData)}",
        lineFlowType: LineFlowType.debug,
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
            "The ${debugObjHtml(globalDataAdapter)}.loadGlobalData() method called with an error!",
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
    _loggedInUser = null;
    _globalData = null;
    Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
    await hiveBox.delete(__hiveKeyLoggedInUser);
    await hiveBox.close();
    ui.updateAllUiComponents();
  }
}
