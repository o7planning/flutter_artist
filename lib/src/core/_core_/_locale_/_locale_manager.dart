part of '../core.dart';

class LocaleManager extends _Core {
  final GlobalsManager _globalsManager;
  final ILocaleAdapter _localeAdapter;
  Locale? locale;

  final String _propName = "*locale*";

  LocaleManager._({
    required GlobalsManager globalsManager,
    required ILocaleAdapter localeAdapter,
  })  : _globalsManager = globalsManager,
        _localeAdapter = localeAdapter;

  ///
  /// Apply Locale and store it in local.
  ///
  Future<void> updateAndStoreLocale({required Locale locale}) async {
    final MasterFlowItem masterFlowItem =
        FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "updateAndStoreLocale",
      parameters: {
        "locale": locale,
      },
      navigate: null,
      isLibCode: true,
    );
    //
    masterFlowItem?._addLineFlowItem(
      codeId: "#46000",
      shortDesc:
          "On the ${_debugObjHtml(this)}.updateAndStoreLocale() method, parameters:",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.calling,
      isLibCall: true,
    );
    masterFlowItem?._addLineFlowItem(
      codeId: "#46100",
      shortDesc:
          "Calling ${_debugObjHtml(this)}._updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.calling,
      isLibCall: true,
    );
    await _updateLocale(masterFlowItem: masterFlowItem, locale: locale);
    //
    final String localeValue =
        "${locale.languageCode}-${locale.countryCode ?? ''}";
    masterFlowItem?._addLineFlowItem(
      codeId: "#46200",
      shortDesc:
          "Calling ${_debugObjHtml(_globalsManager)}._storeExtraGlobalProp():",
      parameters: {
        "propName": _propName,
        "value": localeValue,
      },
      lineFlowType: LineFlowType.calling,
      isLibCall: true,
    );
    await _globalsManager._storeExtraGlobalProp(
      masterFlowItem: masterFlowItem,
      propName: _propName,
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
          "Calling ${_debugObjHtml(_localeAdapter)}.updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      lineFlowType: LineFlowType.calling,
      tipDocument: TipDocument.locale,
    );
    await _localeAdapter.updateLocale(locale);
  }

  Locale? _readStoredLocale({
    required MasterFlowItem? masterFlowItem,
  }) {
    // localeId: "languageCode-countryCode'.
    String? localeId = _globalsManager.getExtraGlobalProp(_propName);
    masterFlowItem?._addLineFlowItem(
      codeId: "#48200",
      shortDesc:
          "@propName: <b>$_propName</b> --> @localeId: <b>$localeId</b>.",
    );
    if (localeId == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#48220",
        shortDesc: "@localeId is null --> nothing to do.",
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
          codeId: "#48240",
          shortDesc: "Found Locale: ${_debugObjHtml(locale)}.",
        );
        return locale;
      }
    }
    masterFlowItem?._addLineFlowItem(
      codeId: "#48260",
      shortDesc: "No Local Found for @localeId: <b>$localeId</b>.",
    );
    return null;
  }
}
