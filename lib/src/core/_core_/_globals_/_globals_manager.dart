part of '../core.dart';

class GlobalsManager extends _Core {
  final String __separator = "\n";

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
      "---flutter-artist-hive-key-logged-in-user---";

  int _loadGlobalDataCount = 0;

  int get loadGlobalDataCount => _loadGlobalDataCount;

  IGlobalData? _globalData;

  ILoggedInUser? _loggedInUser;

  ILoggedInUser? get loggedInUser => _loggedInUser;

  IGlobalData? get globalData => _globalData;

  final ILoggedInUserAdapter loggedInUserAdapter;

  final IGlobalDataAdapter globalDataAdapter;

  ///
  /// For example: {"language", "theme"}
  ///
  final Set<String> __registeredExtraPropNames = {};

  Set<String> get registeredExtraPropNames => {...__registeredExtraPropNames};

  final Map<String, dynamic> __extraPropMap = {};

  final ui = _LoggedInUserUIComponents();

  GlobalsManager._({
    required this.loggedInUserAdapter,
    required this.globalDataAdapter,
  });

  String __getHiveExtraGlobalPropNamesKey() {
    String key = __prefixHiveExtraPropNamesKey;
    if (_loggedInUser != null) {
      key = "$key-**-${_loggedInUser!.userName}";
    }
    return key;
  }

  String __getHiveExtraGlobalPropNameKey(String propName) {
    String key = __prefixHiveExtraPropNameKey;
    if (_loggedInUser != null) {
      key = "$key-**-$propName-**-${_loggedInUser!.userName}";
    }
    return key;
  }

  ///
  /// Extra Global Prop Names. For Example:
  /// - language
  /// - theme
  ///
  Future<void> __readExtraGlobalProps(MasterFlowItem? masterFlowItem) async {
    masterFlowItem?._addLineFlowItem(
      codeId: "#GM300",
      shortDesc:
          "Open <b>HiveBox</b> to read <b>Extra Global Props</b> from local.",
    );
    // Store on local device:
    Box<String> hiveBox = await HiveUtils.openHiveBoxExtraGlobalPropNames();
    try {
      // $key-**-${_loggedInUser!.userName}
      String key = __getHiveExtraGlobalPropNamesKey();
      String extraGlobalPropNames = hiveBox.get(key) ?? "";
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM320",
        shortDesc:
            " - @key: $key --> @extraGlobalPropNames: $extraGlobalPropNames.",
      );
      List<String> propNames = extraGlobalPropNames
          .split(__separator)
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      masterFlowItem?._addLineFlowItem(
        codeId: "#GM340",
        shortDesc: " - @propNames: $propNames.",
      );
      //
      __registeredExtraPropNames
        ..clear()
        ..addAll(propNames);
    } catch (e, stackTrace) {
      print("Error __readExtraGlobalProps: $e");
      print(stackTrace);
      //
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM360",
        shortDesc: "Has an error.",
        errorInfo: errorInfo,
      );
      return;
    } finally {
      await hiveBox.close();
    }
    //
    for (String propName in __registeredExtraPropNames) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM370",
        shortDesc: "Reading prop '$propName' from HiveBox...",
      );
      dynamic value = await __readExtraGlobalProp(propName);
      __extraPropMap[propName] = value;
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM380",
        shortDesc: "Read: @key: $propName --> @value: $value",
      );
    }
  }

  Future<bool> __storeExtraGlobalPropNames() async {
    DebugPrinter.printDebug(
        DebugCat.globalManager, "   --- __storeExtraGlobalPropNames()...");
    // Store on local device:
    Box<String> hiveBox = await HiveUtils.openHiveBoxExtraGlobalPropNames();
    try {
      String key = __getHiveExtraGlobalPropNamesKey();
      String value = __registeredExtraPropNames.toList().join(__separator);
      DebugPrinter.printDebug(DebugCat.globalManager,
          "   --- __storeExtraGlobalPropNames(). key: $key");
      DebugPrinter.printDebug(DebugCat.globalManager,
          "   --- __storeExtraGlobalPropNames(). value: $value");
      await hiveBox.put(key, value);
      return true;
    } catch (e, stackTrace) {
      print("Error __storeExtraGlobalPropNames: $e");
      print(stackTrace);
      return false;
    } finally {
      await hiveBox.close();
    }
  }

  Future<dynamic> __readExtraGlobalProp(String propName) async {
    Box<dynamic> hiveBox = await HiveUtils.openHiveBoxExtraGlobalProp();
    try {
      String key = __getHiveExtraGlobalPropNameKey(propName);
      dynamic value = hiveBox.get(key);
      return value;
    } finally {
      await hiveBox.close();
    }
  }

  dynamic getExtraGlobalProp(String propName) {
    return __extraPropMap[propName];
  }

  Future<void> _storeExtraGlobalProp(String propName, dynamic value) async {
    DebugPrinter.printDebug(DebugCat.globalManager,
        "GlobalManager ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> storeExtraGlobalProp()...");
    __registeredExtraPropNames.add(propName);
    DebugPrinter.printDebug(
        DebugCat.globalManager, "   --- propName: $propName");
    DebugPrinter.printDebug(DebugCat.globalManager,
        "   --- __registeredExtraPropNames: $__registeredExtraPropNames");
    bool success = await __storeExtraGlobalPropNames();
    if (!success) {
      return;
    }
    //
    __extraPropMap[propName] = value;
    //
    Box<dynamic> hiveBox = await HiveUtils.openHiveBoxExtraGlobalProp();
    String key = __getHiveExtraGlobalPropNameKey(propName);
    await hiveBox.put(key, value);
    await hiveBox.close();
    DebugPrinter.printDebug(
        DebugCat.globalManager, "   --- hiveBox.put: key: $key, value: $value");
  }

  ///
  /// This method is called only once when FlutterArtist is started.
  ///
  Future<void> _init(MasterFlowItem? masterFlowItem) async {
    masterFlowItem?._addLineFlowItem(
      codeId: "#GM000",
      shortDesc:
          "Open <b>HiveBox</b> to read user information that was previously saved locally.",
    );
    Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
    masterFlowItem?._addLineFlowItem(
      codeId: "#GM020",
      shortDesc: "Read <b>LoggedInUser JSON String</b> from <b>HiveBox</b>.\n"
          "<i>This information has been stored locally when the user successfully logged in before.</i>",
    );
    String? loggedInUserJson = hiveBox.get(__hiveKeyLoggedInUser);
    await hiveBox.close();

    if (loggedInUserJson == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM040",
        shortDesc: "Read @loggedInUserJson: null.",
      );
      return;
    }
    if (loggedInUserJson == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM060",
        shortDesc: "Read @loggedInUserJson: not null.",
      );
      return;
    }
    ILoggedInUser? loggedInUser;
    try {
      if (loggedInUserJson == null) {
        masterFlowItem?._addLineFlowItem(
          codeId: "#GM080",
          shortDesc: "Call ${_debugObjHtml(loggedInUserAdapter)}.fromJson() "
              "to convert above JSON to ${getTypeNameWithoutGenerics(ILoggedInUser)} object.",
        );
        return;
      }
      loggedInUser = loggedInUserAdapter.fromJson(loggedInUserJson);
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM100",
        shortDesc: "Got @loggedInUser: ${_debugObjHtml(loggedInUser)}.",
      );
    } catch (e, stackTrace) {
      print("****************************************************************");
      print("Error ${getClassName(loggedInUserAdapter)}.fromJson(): $e");
      print("****************************************************************");
      print(stackTrace);
      //
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM120",
        shortDesc:
            "The ${_debugObjHtml(loggedInUserAdapter)}.fromJson() method was called with an error. "
            "You need to log in again via the login page.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    if (loggedInUser == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM140",
        shortDesc:
            "The ${_debugObjHtml(loggedInUserAdapter)}.fromJson() method returned null. "
            "You need to log in again via the login page.",
      );
      return;
    }
    //
    // SAME-AS: #0020
    //
    final ILoggedInUser? loggedInUserBACKUP = _loggedInUser;
    //
    // IMPORTANT: Set before calling globalData.
    // (Do not remove this line).
    //
    _loggedInUser = loggedInUser;
    //
    IGlobalData? globalData;
    try {
      _loadGlobalDataCount++;
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM160",
        shortDesc:
            "Calling ${_debugObjHtml(loggedInUserAdapter)}.loadGlobalData() method "
            "to load global data for @loggedInUser: ${_debugUserHtml(loggedInUser)}.\n"
            "<i>This information has been stored locally when the user successfully logged in before.</i>",
        lineFlowType: LineFlowType.calling,
      );
      // Load Global Data:
      globalData = await globalDataAdapter.loadGlobalData(
        loggedInUser: loggedInUser,
      );
    } catch (e, stackTrace) {
      // Restore!!
      _loggedInUser = loggedInUserBACKUP;
      //
      print("****************************************************************");
      print("Error ${getClassName(globalDataAdapter)}.loadGlobalData(): $e");
      print("****************************************************************");
      print(stackTrace);
      //
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM200",
        shortDesc:
            "The ${_debugObjHtml(loggedInUserAdapter)}.loadGlobalData() method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
    if (globalData == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#GM220",
        shortDesc:
            "The ${_debugObjHtml(loggedInUserAdapter)}.loadGlobalData() method returned null. <i>Requires not null.</i>",
      );
      // This will open login screen.
      return;
    }
    _globalData = globalData;
    //
    masterFlowItem?._addLineFlowItem(
      codeId: "#GM240",
      shortDesc:
          "Reading <b>Extra Global Props</b> from Local. For example: favorite locale and theme.\n"
          "<i>This information is stored locally when the user selects a preferred theme or locale.</i>",
      tipDocument: TipDocument.localeAndTheme,
    );
    // Load Extra Global Prop Names that stored in Hive Database.
    await __readExtraGlobalProps(masterFlowItem);
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
  /// This method is called when the user logs in successfully.
  ///
  Future<bool> _setOrUpdateLoggedInUser({
    required MasterFlowItem? masterFlowItem,
    required ILoggedInUser loggedInUser,
    required bool requiresTheSameUser,
  }) async {
    if (requiresTheSameUser &&
        _loggedInUser != null &&
        _loggedInUser!.userName != loggedInUser.userName) {
      final errorMessage = "The new and old user must have the same 'userName'"
          " or you must log out before calling this method.";
      final List<String>? errorDetails = null;
      //
      showErrorSnackBar(
        message: errorMessage,
        errorDetails: errorDetails,
      );
      //
      masterFlowItem?._addLineFlowItem(
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
    //
    // SAME-AS: #0020
    //
    final ILoggedInUser? loggedInUserBACKUP = _loggedInUser;
    //
    // IMPORTANT: Set before calling globalData.
    // (Do not remove this line).
    //
    _loggedInUser = loggedInUser;
    //
    try {
      // Load GlobalData:
      masterFlowItem?._addLineFlowItem(
        codeId: "#22040",
        shortDesc:
            "Calling ${_debugObjHtml(globalDataAdapter)}.loadGlobalData() to load global data for @loggedInUser:"
            "\n - @loggedInUser: ${_debugObjHtml(loggedInUser)}."
            "\n<i>You can access global data via </i><b>FlutterArtist.globalsManager.globalData</b>.",
        lineFlowType: LineFlowType.calling,
      );
      _loadGlobalDataCount++;
      IGlobalData globalData = await globalDataAdapter.loadGlobalData(
        loggedInUser: loggedInUser,
      );
      _globalData = globalData;
      masterFlowItem?._addLineFlowItem(
        codeId: "#22080",
        shortDesc: "Got @globalData: ${_debugObjHtml(globalData)}",
        lineFlowType: LineFlowType.debug,
      );
    } catch (e, stackTrace) {
      // Restore:
      _loggedInUser = loggedInUserBACKUP;
      //
      ErrorInfo errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      showErrorSnackBar(
        message: errorInfo.errorMessage,
        errorDetails: errorInfo.errorDetails,
      );
      masterFlowItem?._addLineFlowItem(
        codeId: "#22100",
        shortDesc:
            "The ${_debugObjHtml(globalDataAdapter)}.loadGlobalData() method called with an error!",
        errorInfo: errorInfo,
      );
      return false;
    }
    //
    _loggedInUser = loggedInUser;
    // Store on local device:
    Box<String> hiveBox = await HiveUtils.openHiveBoxLoggedInUser();
    try {
      masterFlowItem?._addLineFlowItem(
        codeId: "#22120",
        shortDesc:
            "Calling ${_debugObjHtml(loggedInUserAdapter)}.toJson()... to convert ${_debugObjHtml(loggedInUser)} to JSON String.",
        lineFlowType: LineFlowType.calling,
      );
      String json = loggedInUserAdapter.toJson(loggedInUser);
      masterFlowItem?._addLineFlowItem(
        codeId: "#22140",
        shortDesc: "Storing the above JSON String to local.",
        lineFlowType: LineFlowType.info,
      );
      await hiveBox.put(__hiveKeyLoggedInUser, json);
      await hiveBox.close();
    } catch (e, stackTrace) {
      final warningHtmlMessage =
          "Warning: Unable to store JSON String to Local..\n"
          "<i>This means that the login information cannot be remembered.</i>";
      final appWarning = _createAppWarning(
          warningHtmlMessage.replaceAll("<i>", "").replaceAll("</i>", ""));
      //
      print(appWarning);
      //
      final errorInfo = ErrorInfo.fromError(
        error: e,
        stackTrace: stackTrace,
      );
      // This is warning.
      masterFlowItem?._addLineFlowItem(
        codeId: "#22180",
        shortDesc: warningHtmlMessage,
        errorInfo: errorInfo,
      );
      return true;
    }
    try {
      ui.updateAllUIComponents();
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
    ui.updateAllUIComponents();
  }
}
