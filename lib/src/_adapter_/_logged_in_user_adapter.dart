part of '../_fa_core.dart';

///
///
interface class ILoggedInUserAdapter {
  String toJson(ILoggedInUser loggedInUser) {
    throw UnimplementedError();
  }

  ILoggedInUser? fromJson(String json) {
    throw UnimplementedError();
  }
}
