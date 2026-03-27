part of '../core.dart';

class LocaleManager extends _Core {
  final GlobalsManager _globalsManager;
  final FlutterArtistLocaleAdapter _localeAdapter;

  LocaleManager._({
    required GlobalsManager globalsManager,
    required FlutterArtistLocaleAdapter localeConfig,
  })  : _globalsManager = globalsManager,
        _localeAdapter = localeConfig;

  Locale? get currentLocale {
    // "en-US".
    String? localeCode = _globalsManager.__faMetadata?.localeCode;
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

  List<Locale> get supportedLocales {
    BuildContext context = FlutterArtist.coreFeaturesAdapter.context;
    if (context == null) {
      return [];
    }
    final widgetsApp = context.findAncestorWidgetOfExactType<WidgetsApp>();
    return widgetsApp?.supportedLocales.toList() ?? [];
  }

  // Future<void> updateLocale(Locale locale) async {
  //   return await _localeConfig._updateLocale(locale);
  // }

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
      navigate: null,
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
