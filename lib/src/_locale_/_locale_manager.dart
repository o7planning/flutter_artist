part of '../../flutter_artist.dart';

class LocaleManager {
  final GlobalsManager _globalsManager;
  final ILocaleAdapter _localeAdapter;
  Locale? locale;

  LocaleManager._({
    required GlobalsManager globalsManager,
    required ILocaleAdapter localeAdapter,
  })
      : _globalsManager = globalsManager,
        _localeAdapter = localeAdapter;

  void storeSelectedLocale({required Locale locale}) {
    //
  }

  Locale? getStoredLocale() {
    return locale;
  }
}
