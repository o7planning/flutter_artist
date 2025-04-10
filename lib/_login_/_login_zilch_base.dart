part of '../flutter_artist.dart';

abstract class LoginZilchBase<USER extends ILoggedInUser> extends Zilch {
  LoginZilchBase({required super.name});

  Future<ApiResult<USER>> callApiLogin();

  Future<void> navigateToSuccessScreen();

  ///
  /// Call this method when user click to Login/Submit button.
  ///
  Future<void> doLogin() async {
    await FlutterArtist.adapter.showOverlay(
      asyncFunction: () async {
        try {
          await __doLogin();
        } finally {
          shelf.updateAllUIComponents();
        }
      },
    );
  }

  Future<void> __doLogin() async {
    ApiResult<USER> result;
    try {
      result = await callApiLogin();
      if (result.isError()) {
        showErrorSnackBar(
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
        );
        return;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiLogin",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return;
    }
    USER? user = result.data;
    if (user == null) {
      showErrorSnackBar(
        message: "No data from ${getClassName(this)}.callApiLogin()",
        errorDetails: null,
      );
      return;
    }
    try {
      await FlutterArtist.setOrUpdateLoggedInUser(user);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "setOrUpdateLoggedInUser",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return;
    }
    // Navigate (After login successful).
    await navigateToSuccessScreen();
  }

// Future<void> processLoginResult(ApiResult<User> result) async {
//   if (result.errorMessage != null) {
//     update();
//     showErrorSnackBar(
//       message: result.errorMessage!,
//       errorDetails: result.errorDetails,
//       duration: const Duration(seconds: 4),
//     );
//     return;
//   }
//   User? loginedInfo = result.data;
//   if (loginedInfo == null) {
//     update();
//
//     showErrorSnackBar(
//       message: "No Login Data returned!",
//       errorDetails: null,
//       duration: const Duration(seconds: 10),
//     );
//     return;
//   }
//   ApiResult<CompanyPage> result2 =
//       await companyProvider.query(token: loginedInfo.token);
//   if (result2.errorMessage != null) {
//     String errorMsg = "Get Company data error: ${result2.errorMessage!}";
//     print(errorMsg);
//     update();
//
//     showErrorSnackBar(
//       message: errorMsg,
//       errorDetails: result2.errorDetails,
//       duration: const Duration(seconds: 10),
//     );
//     return;
//   }
//   CompanyPage companyPage = result2.data!;
//   loginedInfo.companyPage = companyPage;
//   //
//   try {
//     // TODO: Cần thư viện hoá chức năng login:
//     await FlutterArtist.setOrUpdateLoggedInUser(loginedInfo);
//   } catch (e, stackTrace) {
//     print(stackTrace);
//     showErrorSnackBar(
//       message: "Error: $e",
//       errorDetails: null,
//       duration: const Duration(seconds: 4),
//     );
//     return;
//   }
//   //
//   Get.offNamed(DashboardScreen.routeName);
// }
}
