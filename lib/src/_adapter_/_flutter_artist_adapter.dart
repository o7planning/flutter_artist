part of '../../flutter_artist.dart';

interface class IFlutterArtistAdapter {
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

  void showErrorSnackBar({
    required String message,
    required List<String>? errorDetails,
  }) {
    throw UnimplementedError();
  }

  void showSavedSnackBar({
    Duration duration = const Duration(seconds: 2),
  }) {
    throw UnimplementedError();
  }

  BuildContext getCurrentContext() {
    throw UnimplementedError();
  }
}
