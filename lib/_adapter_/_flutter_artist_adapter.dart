part of '../flutter_artist.dart';

interface class FlutterArtistAdapter {
  Future<dynamic> showOverlay({
    double opacity = 0,
    required Future<dynamic> Function() asyncFunction,
  }) {
    throw UnimplementedError();
  }

  bool isOverlaysOpen() {
    throw UnimplementedError();
  }

  void closeAllDialogs() {
    throw UnimplementedError();
  }

  void showErrorSnackbar({
    required String message,
    required List<String>? errorDetails,
  }) {
    throw UnimplementedError();
  }

  BuildContext getCurrentContext() {
    throw UnimplementedError();
  }

  void navigationBack() {
    throw UnimplementedError();
  }
}
