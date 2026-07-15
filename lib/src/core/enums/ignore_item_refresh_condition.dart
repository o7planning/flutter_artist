enum IgnoreItemRefreshCondition {
  ///
  /// Conditions to skip ITEM refresh:
  ///
  /// ITEM same as ITEM_DETAIL
  /// and Block has no Form.
  /// and Block has no children.
  ///
  itemSameItemDetailAndNoFormNoChild,

  ///
  /// Conditions to skip ITEM refresh:
  ///
  /// ITEM same as ITEM_DETAIL
  /// and Block has no Form
  /// and Block has no children
  /// and ITEM in new queried list.
  ///
  itemSameItemDetailAndNoFormNoChildAndInNewQuery;
}
