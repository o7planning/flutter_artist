part of '../../core.dart';

class BlockFormSaveResult extends ExecutionUnitResult<BlockFormSavePrecheck> {
  BlockFormSaveResult({required super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
