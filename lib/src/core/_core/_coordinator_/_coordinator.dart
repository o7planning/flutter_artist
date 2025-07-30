part of '../../_fa_core.dart';

abstract class Coordinator extends _XBase {
  final CoordinatorConfig config;
  void Function()? customNavigate;

  Coordinator({
    required this.config,
    required this.customNavigate,
  });

  Future<bool> execute() async {
    bool success;
    try {
      success = await coordinationLogic();
    } catch (e, stackTrace) {
      // Test Cases: [90a].
      _handleError(
        shelf: null,
        methodName: "coordinationLogic",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      success = false;
    }
    switch (config.navCondition) {
      case CoordinatorNavCondition.any:
        _navigate();
      case CoordinatorNavCondition.success:
        if (success) {
          _navigate();
        }
      case CoordinatorNavCondition.error:
        if (!success) {
          _navigate();
        }
    }
    return success;
  }

  void _navigate() async {
    String methodName = "";
    try {
      if (customNavigate != null) {
        methodName = "customNavigate";
        customNavigate!();
      } else {
        methodName = "defaultNavigate";
        defaultNavigate();
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: null,
        methodName: methodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
    }
  }

  ///
  /// Do not call this method. Call execute() instead.
  ///
  Future<bool> coordinationLogic();

  Future<void> defaultNavigate();
}
