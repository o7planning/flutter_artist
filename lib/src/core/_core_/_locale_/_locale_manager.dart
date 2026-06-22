part of '../core.dart';

class LocaleManager extends _Core {
  final GlobalsManager _globalsManager;
  final FlutterArtistLocaleAdapter _localeAdapter;

  /// Internal memory cache allocation to completely eliminate redundant
  /// heavy collection traversal cycles on Flutter Web runtime.
  List<LocaleProfile>? _computedProfilesCache;

  LocaleManager._({
    required GlobalsManager globalsManager,
    required FlutterArtistLocaleAdapter localeAdapter,
  })  : _globalsManager = globalsManager,
        _localeAdapter = localeAdapter;

  /// Exposes the core localized asset dictionary loader delegate infrastructure.
  ///
  /// Client applications must inject this token gateway directly into their
  /// [MaterialApp.localizationsDelegates] collection during initialization.
  LocalizationsDelegate<dynamic> get localizationsDelegate =>
      const LocaleNamesLocalizationsDelegate();

  Locale? get storedLocale {
    // "en-US".
    String? localeCode = _globalsManager._faMetadata?.localeCode;
    if (localeCode == null) {
      return null;
    }
    try {
      // @supportedLocales: Error if BuildContext not ready.
      for (Locale locale in supportedLocales) {
        String code = "${locale.languageCode}-${locale.countryCode ?? ''}";
        if (code == localeCode) return locale;
      }
    } catch (e) {
      return LocaleUtils.fromCode(localeCode);
    }
    return null;
  }

  /// A customizable profile comparator layout configuration.
  ///
  /// Developers can override this callback directly to enforce custom sorting
  /// pipelines (e.g., sorting by ISO codes or English naming conventions).
  int Function(LocaleProfile a, LocaleProfile b)? profileComparator;

  /// Exposes the dynamically compiled profile registry tracking native string naming layouts.
  List<LocaleProfile> get supportedLocalesProfiles {
    if (_computedProfilesCache != null) return _computedProfilesCache!;

    final context = FlutterArtistCore.context;
    final List<Locale> targets = supportedLocales;
    if (targets.isEmpty) return const [];

    final List<LocaleProfile> compiled = [];
    final Map<String, String>? englishLocaleMap = LocaleNames.of(context)?.data;

    for (Locale locale in targets) {
      final String lookupKey = locale.toString();
      final String? nativeLang = LocaleNames.of(context)?.nameOf(lookupKey) ??
          LocaleNames.of(context)?.nameOf(locale.languageCode);
      final String? englishLang = englishLocaleMap?[lookupKey] ??
          englishLocaleMap?[locale.languageCode];
      final String? flag = CountryUtils.getFlag(locale.languageCode);

      compiled.add(
        LocaleProfile(
          locale: locale,
          languageNativeName: nativeLang ?? locale.languageCode.toUpperCase(),
          languageEnglishName: englishLang ?? locale.languageCode.toUpperCase(),
          emojiFlag: flag,
        ),
      );
    }

    // THE MAGIC: Execute the custom sorting pipeline if provided,
    // otherwise fallback elegantly to the native alphabetic sorting mechanism.
    if (profileComparator != null) {
      compiled.sort(profileComparator);
    } else {
      compiled
          .sort((a, b) => a.languageNativeName.compareTo(b.languageNativeName));
    }

    _computedProfilesCache = List.unmodifiable(compiled);
    return _computedProfilesCache!;
  }

  /// Public API allowing developers to dynamically update the sorting algorithm at runtime.
  void setProfileSortingRules(
      int Function(LocaleProfile a, LocaleProfile b)? comparator) {
    profileComparator = comparator;
    // Clear cache allocation to force re-computation cycle
    _computedProfilesCache = null;
  }

  List<Locale> get supportedLocales {
    final context = FlutterArtistCore.context;
    final widgetsApp = context.findAncestorWidgetOfExactType<WidgetsApp>();
    return widgetsApp?.supportedLocales.toList() ?? const [];
  }

  Locale? get currentLocale {
    final context = FlutterArtistCore.context;
    final widgetsApp = context.findAncestorWidgetOfExactType<WidgetsApp>();
    if (widgetsApp?.locale != null) {
      return widgetsApp!.locale;
    }
    return Localizations.maybeLocaleOf(context);
  }

  ///
  /// Apply Locale and store it in local.
  ///
  Future<void> updateAndStoreLocale({required Locale locale}) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "updateAndStoreLocale",
      parameters: {
        "locale": locale,
      },
      isLibMethod: true,
    );
    //
    final ILoggedInUser? loggedInUser = _globalsManager.loggedInUser;
    if (loggedInUser == null) {
      executionTrace._addTraceStep(
        codeId: "#46000",
        shortDesc: "No LoggedInUser --> Nothing to do!",
      );
      return;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#46040",
      shortDesc: "On the ${debugObjHtml(this)}.updateAndStoreLocale() method.",
      parameters: {
        "locale": locale,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    executionTrace._addTraceStep(
      codeId: "#46100",
      shortDesc:
          "Calling ${debugObjHtml(this)}._updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    // Refresh UI with new Locale.
    await _updateLocale(executionTrace: executionTrace, locale: locale);
    //
    final String localeValue =
        "${locale.languageCode}-${locale.countryCode ?? ''}";
    //
    executionTrace._addTraceStep(
      codeId: "#46200",
      shortDesc: "Calling ${debugObjHtml(FaIsarStorage)}.saveSettings():",
      parameters: {
        "userId": loggedInUser.userName,
        "locale": localeValue,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    print("@SAVE localeValue --> Call FaIsarStorage.saveSettings()");
    FaIsarStorage.saveSettings(
        userId: loggedInUser.userName, locale: localeValue);
  }

  Future<void> _updateLocale({
    required ExecutionTrace executionTrace,
    required Locale locale,
  }) async {
    executionTrace._addTraceStep(
      codeId: "#47100",
      shortDesc:
          "Calling ${debugObjHtml(_localeAdapter)}.updateLocale() with parameters:",
      parameters: {
        "locale": locale,
      },
      traceStepType: TraceStepType.controllableCalling,
      tipDocument: TipDocument.locale,
    );
    await _localeAdapter._updateLocale(locale);
  }
}
