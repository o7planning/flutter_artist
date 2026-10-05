part of '__utils.dart';

class PrintUtils {
  static void debug(bool enable, String message) {
    if (enable) {
      print(message);
    }
  }
}
