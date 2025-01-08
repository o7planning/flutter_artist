part of '../flutter_artist.dart';

// =============================================================================
// =============================================================================

enum FluHiddenBehavior {
  none,
  clear;
}

// =============================================================================
// =============================================================================

enum BlockHiddenBehavior {
  none,
  clear;
}

// =============================================================================
// =============================================================================

enum ScalarHiddenBehavior {
  none,
  clear;
}

// =============================================================================
// =============================================================================

enum ListBehavior {
  replace,
  append,
}

// =============================================================================
// =============================================================================

enum CodeFlowItemType {
  blockMethod,
  blockFilterMethod,
  blockFormMethod,
}

enum CodeFlowType {
  methodCalled,
  info,
  error;
}

// =============================================================================
// =============================================================================

enum NliType {
  independent,
  listener,
  notifier;
}

enum FormMode {
  creation,
  edit,
  none;
}

extension FormModeE on FormMode {
  String get tooltip {
    switch (this) {
      case FormMode.creation:
        return "Creation mode";
      case FormMode.edit:
        return "Edit mode";
      case FormMode.none:
        return "None mode";
    }
  }
}

enum AfterQuickAction {
  refreshCurrentItem,
  query;
}

enum AfterSaveAction {
  backAndRefresh,
  refresh;
}

enum FormDebugItemType {
  info,
  call,
}

enum DataState {
  ready,
  pending,
  error;
}

enum QueryMode {
  lazy,
  eager;
}

enum QueryType {
  /// Clear all data.
  emptyQuery,

  /// Force query.
  forceQuery,

  /// Query If need.
  queryIfNeed,
}

enum PostQueryBehavior {
  /// Select an available item in the List or switch to non-selected if List is empty.
  selectAvailableItem,

  /// Select an available item in the List and prepare form to edit.
  selectAvailableItemToEdit,

  // Create new item.
  createNewItem,
}

enum ShowMode {
  dev,
  production;
}

enum WidgetStateType {
  pagination,
  filter,
  controlBar,
  customControlBar,
  form,
  blockFragment,
  shelfFragment,
  //
  scalarFragment,
  loggedInUser;
}
