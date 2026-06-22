part of '../core.dart';

/// A high-end encapsulated metadata profile containing comprehensive localized
/// descriptors extracted directly from core framework environment configurations.
class LocaleProfile {
  final Locale locale;
  final String languageNativeName;
  final String languageEnglishName;
  final String? countryNativeName;
  final String? scriptTypeName;
  final String? emojiFlag;

  const LocaleProfile({
    required this.locale,
    required this.languageNativeName,
    required this.languageEnglishName,
    this.countryNativeName,
    this.scriptTypeName,
    this.emojiFlag,
  });

  /// Returns a clean semantic native display label for UI dropdowns.
  /// Example: "Tiếng Việt (Việt Nam)" or "简体中文 (中国)"
  String get nativeDisplayLabel {
    if (countryNativeName != null) {
      return "$languageNativeName ($countryNativeName)";
    }
    return languageNativeName;
  }

  /// Returns an international translation descriptor helper.
  /// Example: "Vietnamese (Viet Nam)"
  String get englishDisplayLabel {
    return languageEnglishName;
  }

  /// Combines the structural emoji flag badge with the native text layout.
  /// Example: " Tiếng Việt (Việt Nam)"
  String get visualMenuLabel {
    final flag = emojiFlag ?? "";
    return "$flag $nativeDisplayLabel".trim();
  }
}
