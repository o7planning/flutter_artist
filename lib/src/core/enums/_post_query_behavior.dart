// TODO-XXX Change to PostQueryAction?
enum PostQueryBehavior {
  /// Clear Current Item.
  clearCurrentItem,

  /// Create new Item.
  createNewItem,

  /// Default behavior.
  selectAnItemAsCurrentIfNeed,

  /// Select an available item in the List or switch to non-selected if List is empty.
  selectAnItemAsCurrent,

  /// Select an available item in the List and prepare form to edit.
  selectAnItemAsCurrentAndLoadForm,
}
