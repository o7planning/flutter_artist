part of '../core.dart';

class ScalarLoadExtraDataResult
    extends ExecutionUnitResult<ScalarLoadExtraDataPrecheck> {
  ScalarLoadExtraDataResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
