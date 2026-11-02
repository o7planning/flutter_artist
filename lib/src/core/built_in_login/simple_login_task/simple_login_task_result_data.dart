part of '../_login.dart';

/// A standard TaskResultData wrapper that holds the authenticated [USER]
/// so that DebugTaskStateView can inspect the user payload without forcing
/// the USER class itself to extend TaskResultData.
class SimpleLoginTaskResultData<USER extends ILoggedInUser>
    extends TaskResultData {
  final USER user;

  SimpleLoginTaskResultData({required this.user});

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      "authenticatedUser": user,
    };
  }
}
