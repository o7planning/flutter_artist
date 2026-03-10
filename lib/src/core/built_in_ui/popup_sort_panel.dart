import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';
import 'popup_sort_panel_style.dart';

class PopupSortPanel<ITEM extends Object> extends SortPanel<ITEM> {
  final PopupSortPanelStyle style;

  const PopupSortPanel({
    super.key,
    required super.sortModel,
    this.style = const PopupSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    return PopupMenuButton<SortCriterion>(
      icon: Icon(
        style.buttonIcon,
        size: style.buttonIconSize,
        color: style.buttonIconColor,
      ),
      itemBuilder: (context) => sortModel.criteria.map((criterion) {
        return PopupMenuItem(
          value: criterion,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                criterion.text,
                style: style.menuTextStyle ?? style.textStyle,
              ),
              buildSortButton(
                context: context,
                sortModel: sortModel,
                criterion: criterion,
                enabled: true,
                isDragging: false,
                iconSize: style.sortIconSize,
                draggingColor: style.draggingColor,
              ),
            ],
          ),
        );
      }).toList(),
      onSelected: (criterion) {
        sortModel.updateSortingCriterionByName(
          criterionName: criterion.criterionName,
          direction: criterion.nextDirection,
          moveToFirst: false,
        );
      },
    );
  }
}
