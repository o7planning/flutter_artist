import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../global/_global_data.dart';

interface class IGlobalDataAdapter<G extends IGlobalData> {
  Future<G> loadGlobalData({
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
