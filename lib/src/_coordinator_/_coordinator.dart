part of '../../flutter_artist.dart';

abstract class Coordinator extends _XBase {
  void Function()? customNavigate;

  Coordinator({required this.customNavigate});

  Future<bool> execute() async {
    try {
      bool success = await coordinationLogic();
      if (!success) {
        return false;
      }
      if (customNavigate != null) {
        customNavigate!();
      } else {
        await defaultNavigate();
      }
      return true;
    } catch (e, stackTrace) {
      showErrorSnackBar(
        message: "${getClassName(this)} execute error",
        errorDetails: ["Error: $e"],
      );
      return false;
    }
  }

  ///
  /// Do not call this method. Call execute() instead.
  ///
  Future<bool> coordinationLogic();

  Future<void> defaultNavigate();
}
