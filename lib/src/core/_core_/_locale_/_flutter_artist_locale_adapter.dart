part of '../core.dart';

class FlutterArtistLocaleAdapter {
  final Future<void> Function(Locale locale) _updateLocale;

  FlutterArtistLocaleAdapter({
    required Future<void> Function(Locale locale) updateLocale,
  }) : _updateLocale = updateLocale;
}
