part of '../core.dart';

class AppFatalErrorUtils {
  static String _createFatalAppError(String message) {
    return "\n*********************************************************************************************\n"
        "$message"
        "\n\n  *** You may need to restart the application after editing the code. ***"
        "\n*********************************************************************************************\n";
  }

  static String _createAppWarning(String message) {
    return "\n*********************************************************************************************\n"
        "---- WARNING ----\n"
        "$message"
        "\n\n  *** You may need to restart the application after editing the code. ***"
        "\n*********************************************************************************************\n";
  }

  static String ___registerError(String message) {
    FlutterArtist._clearActivitiesAndShelves();
    //
    return _createFatalAppError(message);
  }
}
