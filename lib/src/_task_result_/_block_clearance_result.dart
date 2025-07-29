part of '../_fa_core.dart';

class BlockClearanceResult extends ActionResult {
  BlockClearancePrecheck? _precheck;

  BlockClearancePrecheck? get precheck => _precheck;

  BlockClearanceResult({BlockClearancePrecheck? precheck})
      : _precheck = precheck;

  @override
  bool get success {
    if (_precheck != null) {
      return false;
    }
    return true;
  }
}
