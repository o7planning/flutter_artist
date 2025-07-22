part of '../../flutter_artist.dart';

class LocaleManager {
  final GlobalsManager _globalsManager;
  final ILocaleAdapter _localeAdapter;
  Locale? locale;

  final String _propName = "@locale";

  LocaleManager._({
    required GlobalsManager globalsManager,
    required ILocaleAdapter localeAdapter,
  })
      : _globalsManager = globalsManager,
        _localeAdapter = localeAdapter;

  ///
  /// Apply Locale and store it in local.
  ///
  Future<void> updateAndStoreLocale({required Locale locale}) async {
    await _updateLocale(locale: locale);
    String id = "${locale.languageCode}-${locale.countryCode ?? ''}";
    await _globalsManager.storeExtraGlobalProp(_propName, id);
  }

  Future<void> _updateLocale({required Locale locale}) async {
    _printDebugState(DebugCat.appStart,
        "  --- localeManager._updateLocale(). locale: $locale");
    await _localeAdapter.updateLocale(locale);
  }

  Locale? readStoredLocale() {
    // id: "languageCode-countryCode'.
    String? id = _globalsManager.getExtraGlobalProp(_propName);
    _printDebugState(DebugCat.appStart,
        "  --- localeManager. readStoredLocale(): _propName: $_propName");
    if (id == null) {
      _printDebugState(DebugCat.appStart,
          "  --- localeManager. readStoredLocale(): value: $id");
      return null;
    }
    List<String> ss = id.split("-");
    if (ss.length < 2) {
      return null;
    }
    final String languageCode = ss[0];
    final String? countryCode = ss[1].isEmpty ? null : ss[1];

    List<Locale> supportedLocales = _localeAdapter.supportedLocales();
    for (Locale locale in supportedLocales) {
      if (locale.languageCode == languageCode &&
          locale.countryCode == countryCode) {
        return locale;
      }
    }
    return null;
  }
}
