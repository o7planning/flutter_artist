part of '../../core.dart';

class BlockQueryResult<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL,
        BlockQueryPrecheck> {
  bool _isFilterError = false;

  BlockQueryResult._();

  BlockQueryResult._busy() : super(precheck: BlockQueryPrecheck.busy);

  BlockQueryResult._precheckFail({required BlockQueryPrecheck precheck})
      : super(precheck: precheck);

  void _setFilterError() {
    // _setPrecheck(BlockQueryPrecheck.filterError);
    _isFilterError = true;
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    if (_isFilterError) {
      return false;
    }
    if (_errorInfo != null) {
      return false;
    }
    return true;
  }
}
