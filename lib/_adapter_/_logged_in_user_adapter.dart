part of '../flutter_artist.dart';

///
///
interface class LoggedInUserAdapter {
  String toJson(FluLoggedInUser fluLoggedInUser) {
    throw UnimplementedError();
  }

  FluLoggedInUser? fromJson(String json) {
    throw UnimplementedError();
  }
}
