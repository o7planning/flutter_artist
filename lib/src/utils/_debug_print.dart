import '../enums/_debug_cat.dart';
import '../core/_fa_core.dart';

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
