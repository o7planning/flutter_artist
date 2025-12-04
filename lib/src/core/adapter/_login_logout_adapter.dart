import 'package:flutter_artist_core/flutter_artist_core.dart';

///
///
interface class ILoginLogoutAdapter {
  String toJson(ILoggedInUser loggedInUser) {
    throw UnimplementedError();
  }

  ILoggedInUser? fromJson(String json) {
    throw UnimplementedError();
  }

  void addThirdPartyLogicOnLogin(ILoggedInUser loggedInUser) {
    throw UnimplementedError();
  }

  void addThirdPartyLogicOnLogout() {
    throw UnimplementedError();
  }
}
