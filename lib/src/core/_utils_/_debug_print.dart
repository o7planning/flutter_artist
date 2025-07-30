import '../../../flutter_artist.dart';

class DebugPrint {
  static void debugPrint(String message) {
    print(message);
  }

  static void printDebugState(DebugCat debugCat, String message) {
    if (FlutterArtist.isAllowDebugCat(debugCat)) {
      debugPrint(message);
    }
  }
}
