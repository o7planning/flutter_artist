part of '../core.dart';

abstract class Coordinator extends _Core {
  final CoordinatorConfig config;
  void Function(BuildContext context, bool success)? customNavigate;

  Coordinator({
    required this.config,
    required this.customNavigate,
  });

  Future<bool> execute(BuildContext context) async {
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
        tipDocument: TipDocument.coordinatorCoordinationLogic,
      );
      success = false;
    }
    _navigate(context, success);
    return success;
  }

  void _navigate(BuildContext context, bool success) async {
    String methodName = "";
    try {
      if (customNavigate != null) {
        methodName = "customNavigate";
        customNavigate!(context, success);
      } else {
        methodName = "defaultNavigate";
        defaultNavigate(context, success);
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: null,
        methodName: methodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  ///
  /// Do not call this method. Call execute() instead.
  ///
  Future<bool> coordinationLogic();

  Future<void> defaultNavigate(BuildContext context, bool success);
}
