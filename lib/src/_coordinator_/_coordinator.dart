part of '../../flutter_artist.dart';

abstract class Coordinator extends _XBase {
  final CoordinatorConfig config;
  void Function()? customNavigate;

  Coordinator({
    required CoordinatorConfig? config,
    required this.customNavigate,
  }) : config = config ?? CoordinatorConfig();

  Future<bool> execute() async {
    bool success;
    try {
      success = await coordinationLogic();
    } catch (e, stackTrace) {
      _handleError(
        shelf: null,
        methodName: "coordinationLogic",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      success = false;
    }
    switch (config.navigationCondition) {
      case CoordinatorNavigationCondition.any:
        _navigate();
      case CoordinatorNavigationCondition.success:
        if (success) {
          _navigate();
        }
      case CoordinatorNavigationCondition.error:
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
