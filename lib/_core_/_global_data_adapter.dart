part of '../flutter_artist.dart';

interface class GlobalDataAdapter<GLOBAL_DATA extends GlobalData<GLOBAL_DATA>> {
  Future<GLOBAL_DATA> loadFromServer({
    required ILoggedInUser loggedInUser,
  }) async {
    throw UnimplementedError();
  }

  String toJson(GLOBAL_DATA globalData) {
    throw UnimplementedError();
  }

  Future<GLOBAL_DATA?> fromJson(String json) {
    throw UnimplementedError();
  }
}
