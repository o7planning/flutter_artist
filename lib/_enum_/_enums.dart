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

enum RefreshableWidgetType {
  pagination,
  filter,
  controlBar,
  customControlBar,
  form,
  blockFragment,
  shelfFragment,
  blockControlButton,
  scalarControlButton,
  //
  scalarFragment,
  loggedInUser;
}

extension WidgetStateTypeE on RefreshableWidgetType {
  String get name {
    switch (this) {
      case RefreshableWidgetType.pagination:
        return "Pagination";
      case RefreshableWidgetType.filter:
        return "DataFilter";
      case RefreshableWidgetType.controlBar:
        return "ControlBar";
      case RefreshableWidgetType.customControlBar:
        return "CustomControlBar";
      case RefreshableWidgetType.form:
        return "BlockForm";
      case RefreshableWidgetType.blockFragment:
        return "BlockFragment";
      case RefreshableWidgetType.shelfFragment:
        return "ShelfFragment";
      case RefreshableWidgetType.scalarFragment:
        return "ScalarFragment";
      case RefreshableWidgetType.loggedInUser:
        return "LoggedInUser";
      case RefreshableWidgetType.blockControlButton:
        return "ControlButton";
      case RefreshableWidgetType.scalarControlButton:
        return "Scalar Control Button";
    }
  }

  IconData get iconData {
    switch (this) {
      case RefreshableWidgetType.filter:
        return _dataFilterIconData;
      case RefreshableWidgetType.controlBar:
        return _blockControlBarIconData;
      case RefreshableWidgetType.customControlBar:
        return _blockCustomControlBarIconData;
      case RefreshableWidgetType.form:
        return _blockFormIconData;
      case RefreshableWidgetType.blockFragment:
        return _blockFragmentIconData;
      case RefreshableWidgetType.pagination:
        return _paginationIconData;
      case RefreshableWidgetType.loggedInUser:
        return _loggedUserIconData;
      case RefreshableWidgetType.scalarFragment:
        return _scalarFragmentIconData;
      case RefreshableWidgetType.shelfFragment:
        return _shelfFragmentIconData;
      case RefreshableWidgetType.blockControlButton:
        return _blockControlButtonIconData;
      case RefreshableWidgetType.scalarControlButton:
        return _scalarControlButtonIconData;
    }
  }
}
