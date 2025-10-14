part of '../core.dart';

abstract class Coordinator extends _Core {
  final CoordinatorConfig config;
  void Function(BuildContext context, {required bool success})? customNavigate;

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
      );
      success = false;
    }
    _navigate(context, success: success);
    // switch (config.navCondition) {
    //   case CoordinatorNavCondition.any:
    //     _navigate(context);
    //   case CoordinatorNavCondition.success:
    //     if (success) {
    //       _navigate(context);
    //     }
    //   case CoordinatorNavCondition.error:
    //     if (!success) {
    //       _navigate(context);
    //     }
    // }
    return success;
  }

  void _navigate(BuildContext context, {required bool success}) async {
    String methodName = "";
    try {
      if (customNavigate != null) {
        methodName = "customNavigate";
        customNavigate!(context, success: success);
      } else {
        methodName = "defaultNavigate";
        defaultNavigate(context, success: success);
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

  Future<void> defaultNavigate(BuildContext context, {required bool success});
}
