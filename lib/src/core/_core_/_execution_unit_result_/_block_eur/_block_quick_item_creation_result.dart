part of '../../core.dart';

@RenameAnnotation()
class BlockQuickItemCreationResult<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL,
        BlockQuickItemCreationPrecheck> {
  BlockQuickItemCreationResult({
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
