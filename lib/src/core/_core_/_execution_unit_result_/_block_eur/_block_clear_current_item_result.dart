part of '../../core.dart';

class BlockClearCurrentItemResult<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL,
        BlockClearCurrentItemPrecheck> {
  BlockClearCurrentItemResult({super.precheck});

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    }
    return true;
  }
}
