part of '_login.dart';

/// A standard TaskResultData wrapper that holds the authenticated [USER]
/// so that DebugTaskStateView can inspect the user payload without forcing
/// the USER class itself to extend TaskResultData.
class LoginTaskResultData<USER extends ILoggedInUser> extends TaskResultData {
  final USER user;

  LoginTaskResultData({required this.user});

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "authenticatedUser": user,
    };
  }
}
