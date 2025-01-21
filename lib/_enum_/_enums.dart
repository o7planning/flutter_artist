part of '../flutter_artist.dart';

// =============================================================================
// =============================================================================

enum ShelfHiddenBehavior {
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

enum FormAction {
  create,
  edit;
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
  dataFilterMethod,
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
  eventSource;
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
  clear,

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

extension WidgetStateTypeE on WidgetStateType {
  String get name {
    switch (this) {
      case WidgetStateType.pagination:
        return "Pagination";
      case WidgetStateType.filter:
        return "DataFilter";
      case WidgetStateType.controlBar:
        return "ControlBar";
      case WidgetStateType.customControlBar:
        return "CustomControlBar";
      case WidgetStateType.form:
        return "BlockForm";
      case WidgetStateType.blockFragment:
        return "BlockFragment";
      case WidgetStateType.shelfFragment:
        return "ShelfFragment";
      case WidgetStateType.scalarFragment:
        return "ScalarFragment";
      case WidgetStateType.loggedInUser:
        return "LoggedInUser";
    }
  }
}
