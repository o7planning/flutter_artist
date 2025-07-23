part of '../../flutter_artist.dart';

class BlockClearResult extends ActionResult {
  BlockClearancePrecheck? _precheck;

  BlockClearancePrecheck? get precheck => _precheck;

  BlockClearResult({BlockClearancePrecheck? precheck}) : _precheck = precheck;

  @override
  bool get success {
    if (_precheck != null) {
      return false;
    }
    return true;
  }
}
