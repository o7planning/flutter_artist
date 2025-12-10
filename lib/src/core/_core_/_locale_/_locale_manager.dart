part of '../core.dart';

class LocaleManager extends _Core {
  final GlobalsManager _globalsManager;
  final ILocaleAdapter _localeAdapter;

  final String propName = "locale";

  LocaleManager._({
    required GlobalsManager globalsManager,
    required ILocaleAdapter localeAdapter,
  })  : _globalsManager = globalsManager,
        _localeAdapter = localeAdapter;

  Locale? get currentLocale {
    return _globalsManager.getExtraGlobalProp(propName);
  }

  ///
  /// Apply Locale and store it in local.
  ///
  Future<void> updateAndStoreLocale({required Locale locale}) async {
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "updateAndStoreLocale",
      parameters: {
        "locale": locale,
      },
      navigate: null,
      isLibMethod: true,
    );
    //
    final ILoggedInUser? loggedInUser = _globalsManager.loggedInUser;
    if (loggedInUser == null) {
      masterFlowItem._addLineFlowItem(
        codeId: "#46000",
        shortDesc: "No LoggedInUser --> Nothing to do!",
      );
      return;
    }
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#46040",
      shortDesc: "On the ${debugObjHtml(this)}.updateAndStoreLocale() method.",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#46100",
      shortDesc:
          "Calling ${debugObjHtml(this)}._updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    // Refresh UI with new Locale.
    await _updateLocale(masterFlowItem: masterFlowItem, locale: locale);
    //
    final String localeValue =
        "${locale.languageCode}-${locale.countryCode ?? ''}";
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#46200",
      shortDesc:
          "Calling ${debugObjHtml(_globalsManager)}._storeExtraGlobalProp():",
      parameters: {
        "loggedInUser": loggedInUser,
        "propName": propName,
        "value": localeValue,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    await _globalsManager._storeExtraGlobalProp(
      masterFlowItem: masterFlowItem,
      loggedInUser: loggedInUser,
      propName: propName,
      value: localeValue,
    );
  }

  Future<void> _updateLocale({
    required MasterFlowItem? masterFlowItem,
    required Locale locale,
  }) async {
    masterFlowItem?._addLineFlowItem(
      codeId: "#47100",
      shortDesc:
          "Calling ${debugObjHtml(_localeAdapter)}.updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.controllableCalling,
      tipDocument: TipDocument.locale,
    );
    await _localeAdapter.updateLocale(locale);
  }

  Locale? _readStoredLocale({
    required ILoggedInUser loggedInUser,
    required MasterFlowItem? masterFlowItem,
  }) {
    masterFlowItem?._addLineFlowItem(
      codeId: "#48000",
      shortDesc:
          "Calling <b>_globalsManager.getExtraGlobalProp()</b> to get <b>localeId</b>.",
      parameters: {
        "propName": propName,
      },
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    // localeId: "languageCode-countryCode'.
    String? localeId = _globalsManager.getExtraGlobalProp(propName);
    masterFlowItem?._addLineFlowItem(
      codeId: "#48200",
      shortDesc: "Got @localeId: <b>$localeId</b>.",
    );
    if (localeId == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#48300",
        shortDesc: "@localeId is <b>null</b> --> nothing to do.",
      );
      return null;
    }
    List<String> ss = localeId.split("-");
    if (ss.length < 2) {
      return null;
    }
    final String languageCode = ss[0];
    final String? countryCode = ss[1].isEmpty ? null : ss[1];

    List<Locale> supportedLocales = _localeAdapter.supportedLocales();
    for (Locale locale in supportedLocales) {
      if (locale.languageCode == languageCode &&
          locale.countryCode == countryCode) {
        masterFlowItem?._addLineFlowItem(
          codeId: "#48400",
          shortDesc: "Found Locale: ${debugObjHtml(locale)}.",
        );
        return locale;
      }
    }
    masterFlowItem?._addLineFlowItem(
      codeId: "#48500",
      shortDesc: "No Local Found for @localeId: <b>$localeId</b>.",
    );
    return null;
  }
}
