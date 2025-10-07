import 'package:flutter/material.dart';

import '../icon/icon_constants.dart';

enum RefreshableWidgetType {
  pagination(
    name: "Pagination",
    iconData: FaIconConstants.paginationIconData,
  ),
  filter(
    name: "FilterModel",
    iconData: FaIconConstants.filterModelIconData,
  ),
  controlBar(
    name: "ControlBar",
    iconData: FaIconConstants.blockControlBarIconData,
  ),
  customControlBar(
    name: "CustomControlBar",
    iconData: FaIconConstants.blockCustomControlBarIconData,
  ),
  form(
    name: "FormModel",
    iconData: FaIconConstants.formModelIconData,
  ),
  blockFragment(
    name: "BlockFragment",
    iconData: FaIconConstants.blockFragmentIconData,
  ),
  blockItemsView(
    name: "BlockItemsView",
    iconData: FaIconConstants.blockItemsViewIconData,
  ),
  shelfFragment(
    name: "ShelfFragment",
    iconData: FaIconConstants.shelfFragmentIconData,
  ),
  blockControlButton(
    name: "ControlButton",
    iconData: FaIconConstants.blockControlButtonIconData,
  ),
  scalarControlButton(
    name: "Scalar Control Button",
    iconData: FaIconConstants.scalarControlButtonIconData,
  ),
  //
  scalarFragment(
    name: "ScalarFragment",
    iconData: FaIconConstants.scalarFragmentIconData,
  ),
  activityFragment(
    name: "ActivityFragment",
    iconData: FaIconConstants.hookFragmentIconData,
  ),
  loggedInUser(
    name: "LoggedInUser",
    iconData: FaIconConstants.loggedUserIconData,
  ),
  //
  taskProgressView(
    name: "Task Progress View",
    iconData: FaIconConstants.taskProgressViewIconData,
  );

  final String name;
  final IconData iconData;

  const RefreshableWidgetType({required this.name, required this.iconData});
}
