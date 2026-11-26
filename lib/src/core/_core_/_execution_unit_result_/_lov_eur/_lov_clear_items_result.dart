part of '../../core.dart';

/// Execution unit result representing the outcome of a [LovModel] clear items operation.
class LovClearItemsResult<
ID extends Comparable, //
ITEM extends Identifiable<ID>>
    extends ExecutionUnitResult<LovClearItemsPrecheck> {
  LovClearItemsResult({
    super.precheck,
    super.errorInfo,
  });

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return errorInfo == null;
  }
}
