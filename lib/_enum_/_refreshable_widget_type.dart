part of '../flutter_artist.dart';

enum RefreshableWidgetType {
  pagination,
  filter,
  controlBar,
  customControlBar,
  form,
  blockFragment,
  blockItemsView,
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
        return "FilterModel";
      case RefreshableWidgetType.controlBar:
        return "ControlBar";
      case RefreshableWidgetType.customControlBar:
        return "CustomControlBar";
      case RefreshableWidgetType.form:
        return "BlockForm";
      case RefreshableWidgetType.blockFragment:
        return "BlockFragment";
      case RefreshableWidgetType.blockItemsView:
        return "BlockItemsView";
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
        return _filterModelIconData;
      case RefreshableWidgetType.controlBar:
        return _blockControlBarIconData;
      case RefreshableWidgetType.customControlBar:
        return _blockCustomControlBarIconData;
      case RefreshableWidgetType.form:
        return _blockFormIconData;
      case RefreshableWidgetType.blockFragment:
        return _blockFragmentIconData;
      case RefreshableWidgetType.blockItemsView:
        return _blockItemsViewIconData;
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
