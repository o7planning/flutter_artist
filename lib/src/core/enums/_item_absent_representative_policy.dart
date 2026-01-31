enum ItemAbsentRepresentativePolicy {
  ///
  /// (Default Behavior). When the Block does not have a UI Component representing the "item" displayed on the interface.
  /// Block will not try to find an Item to set as current.
  ///
  tryNotSetAnItemAsCurrent,

  ///
  /// When the Block does not have a UI Component representing the "item" displayed on the interface.
  /// Block will try to find an Item to set as the current item if that item belongs to the list just queried and ITEM == ITEM_DETAIL.
  /// This will ensure that no additional Rest API calls are needed to retrieve ITEM details.
  ///
  trySetAnItemAsCurrent;
}

enum UniformItemRefreshPolicy {
  always,
  auto;
}
