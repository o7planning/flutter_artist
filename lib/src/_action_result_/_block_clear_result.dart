part of '../../flutter_artist.dart';

class BlockClearResult extends ActionResult {
  BlockClearPrecheck? _precheck;

  BlockClearResult({BlockClearPrecheck? precheck}) : _precheck = precheck;

  @override
  bool get success {
    return _precheck != null;
  }
}
