part of '../flutter_artist.dart';

///
///
interface class LoggedInUserAdapter {
  String toJson(ILoggedInUser fluLoggedInUser) {
    throw UnimplementedError();
  }

  ILoggedInUser? fromJson(String json) {
    throw UnimplementedError();
  }
}
