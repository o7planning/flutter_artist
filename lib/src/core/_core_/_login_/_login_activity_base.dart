part of '../core.dart';

abstract class LoginActivityBase<USER extends ILoggedInUser> extends Activity {
  LoginActivityBase({required super.name, required super.config});

  Future<ApiResult<USER>> callApiLogin();

  Future<void> navigateToSuccessScreen();

  ///
  /// Call this method when user click to Login/Submit button.
  ///
  Future<void> doLogin() async {
    try {
      bool success = await FlutterArtist.adapter.showOverlay(
        asyncFunction: () async {
          return await __doLogin();
        },
      );
      if (success) {
        print("Success");
        await navigateToSuccessScreen();
      } else {
        shelf.ui.updateAllUIComponents();
      }
    } finally {
      // shelf.updateAllUIComponents();
    }
  }

  Future<bool> __doLogin() async {
    ApiResult<USER> result;
    try {
      result = await callApiLogin();
      if (result.error != null) {
        showErrorSnackBar(
          message: result.error!.errorMessage,
          errorDetails: result.error!.errorDetails,
        );
        return false;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLogin",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    USER? user = result.data;
    if (user == null) {
      showErrorSnackBar(
        message: "No data from ${getClassName(this)}.callApiLogin()",
        errorDetails: null,
      );
      return false;
    }
    try {
      await FlutterArtist.setOrUpdateLoggedInUser(user);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "FlutterArtist.setOrUpdateLoggedInUser",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    return true;
  }
}
