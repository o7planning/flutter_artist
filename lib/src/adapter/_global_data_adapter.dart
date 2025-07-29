

import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../flutter_artist.dart';

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
