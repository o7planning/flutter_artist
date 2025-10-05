import '../_core_/core.dart';
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

  static String getFatalError(String message) {
    return "\n*********************************************************************************************\n"
        "$message"
        "\n*********************************************************************************************\n";
  }
}
