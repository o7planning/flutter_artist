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
    await _updateLocale(masterFlowItem: null, locale: locale);
    String id = "${locale.languageCode}-${locale.countryCode ?? ''}";
    await _globalsManager._storeExtraGlobalProp(_propName, id);
  }

  Future<void> _updateLocale({
    required MasterFlowItem? masterFlowItem,
    required Locale locale,
  }) async {
    masterFlowItem?._addLineFlowItem(
      codeId: "#LM100",
      shortDesc:
          "Calling ${_debugObjHtml(_localeAdapter)}.updateLocale() with parameter $locale.",
    );
    await _localeAdapter.updateLocale(locale);
  }

  Locale? _readStoredLocale({
    required MasterFlowItem? masterFlowItem,
  }) {
    // localeId: "languageCode-countryCode'.
    String? localeId = _globalsManager.getExtraGlobalProp(_propName);
    masterFlowItem?._addLineFlowItem(
      codeId: "#LM200",
      shortDesc:
          "Read Stored Locale @propName: $_propName --> @localeId: $localeId.",
    );
    if (localeId == null) {
      masterFlowItem?._addLineFlowItem(
        codeId: "#LM220",
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
          codeId: "#LM240",
          shortDesc: "Found Locale: $locale.",
        );
        return locale;
      }
    }
    masterFlowItem?._addLineFlowItem(
      codeId: "#LM260",
      shortDesc: "No Local Found for @localeId: $localeId.",
    );
    return null;
  }
}
