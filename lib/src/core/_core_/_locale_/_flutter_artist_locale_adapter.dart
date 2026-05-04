part of '../core.dart';

///
/// Docs: [14883]
///
class FlutterArtistLocaleAdapter {
  final Future<void> Function(Locale locale) _updateLocale;

  FlutterArtistLocaleAdapter({
    required Future<void> Function(Locale locale) updateLocale,
  }) : _updateLocale = updateLocale;
}
