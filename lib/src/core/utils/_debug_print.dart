import '../_fa_core.dart';
import '../enums/_debug_cat.dart';

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
