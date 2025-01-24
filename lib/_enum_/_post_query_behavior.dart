part of '../flutter_artist.dart';

enum PostQueryBehavior {
  /// Select an available item in the List or switch to non-selected if List is empty.
  selectAvailableItem,

  /// Select an available item in the List and prepare form to edit.
  selectAvailableItemToEdit,

  // Create new item.
  createNewItem,
}
