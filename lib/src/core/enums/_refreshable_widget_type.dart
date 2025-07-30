import 'package:flutter/material.dart';

import '../icon/icon_constants.dart';

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
  activityFragment,
  loggedInUser,
  //
  taskProgressView;
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
        return "FormModel";
      case RefreshableWidgetType.blockFragment:
        return "BlockFragment";
      case RefreshableWidgetType.blockItemsView:
        return "BlockItemsView";
      case RefreshableWidgetType.shelfFragment:
        return "ShelfFragment";
      case RefreshableWidgetType.scalarFragment:
        return "ScalarFragment";
      case RefreshableWidgetType.activityFragment:
        return "ActivityFragment";
      case RefreshableWidgetType.loggedInUser:
        return "LoggedInUser";
      case RefreshableWidgetType.blockControlButton:
        return "ControlButton";
      case RefreshableWidgetType.scalarControlButton:
        return "Scalar Control Button";
      case RefreshableWidgetType.taskProgressView:
        return "Task Progress View";
    }
  }

  IconData get iconData {
    switch (this) {
      case RefreshableWidgetType.filter:
        return FaIconConstants.filterModelIconData;
      case RefreshableWidgetType.controlBar:
        return FaIconConstants.blockControlBarIconData;
      case RefreshableWidgetType.customControlBar:
        return FaIconConstants.blockCustomControlBarIconData;
      case RefreshableWidgetType.form:
        return FaIconConstants.formModelIconData;
      case RefreshableWidgetType.blockFragment:
        return FaIconConstants.blockFragmentIconData;
      case RefreshableWidgetType.blockItemsView:
        return FaIconConstants.blockItemsViewIconData;
      case RefreshableWidgetType.pagination:
        return FaIconConstants.paginationIconData;
      case RefreshableWidgetType.loggedInUser:
        return FaIconConstants.loggedUserIconData;
      case RefreshableWidgetType.scalarFragment:
        return FaIconConstants.scalarFragmentIconData;
      case RefreshableWidgetType.activityFragment:
        return FaIconConstants.activityFragmentIconData;
      case RefreshableWidgetType.shelfFragment:
        return FaIconConstants.shelfFragmentIconData;
      case RefreshableWidgetType.blockControlButton:
        return FaIconConstants.blockControlButtonIconData;
      case RefreshableWidgetType.scalarControlButton:
        return FaIconConstants.scalarControlButtonIconData;
      case RefreshableWidgetType.taskProgressView:
        return FaIconConstants.taskProgressViewIconData;
    }
  }
}
