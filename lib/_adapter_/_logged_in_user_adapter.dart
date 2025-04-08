part of '../flutter_artist.dart';

///
///
interface class LoggedInUserAdapter {
  String toJson(ILoggedInUser loggedInUser) {
    throw UnimplementedError();
  }

  ILoggedInUser? fromJson(String json) {
    throw UnimplementedError();
  }
}
