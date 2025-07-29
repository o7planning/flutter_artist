part of '../_fa_core.dart';

interface class IGlobalDataAdapter<G extends IGlobalData> {
  Future<G> loadFromServer({
    required ILoggedInUser loggedInUser,
  }) async {
    throw UnimplementedError();
  }

  String toJson(G globalData) {
    throw UnimplementedError();
  }

  G? fromJson(String json) {
    throw UnimplementedError();
  }
}
