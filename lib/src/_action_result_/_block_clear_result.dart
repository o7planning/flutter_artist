part of '../../flutter_artist.dart';

class BlockClearResult extends ActionResult {
  BlockClearPrecheck? _precheck;

  BlockClearPrecheck? get precheck => _precheck;

  BlockClearResult({BlockClearPrecheck? precheck}) : _precheck = precheck;

  @override
  bool get success {
    if (_precheck != null) {
      return false;
    }
    return true;
  }
}
