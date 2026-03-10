import 'package:flutter/material.dart';

import '../_core_/core.dart';
import '_sorting_options.dart';

abstract class SortPanelStyle {
  final TextStyle textStyle;
  final double iconSpacing;
  final double sortIconSize;
  final Color? draggingColor;

  const SortPanelStyle({
    this.textStyle = const TextStyle(fontSize: 14),
    this.iconSpacing = 4,
    this.sortIconSize = 16,
    this.draggingColor,
  });
}

class SortCriterionTile<ITEM extends Object> extends StatelessWidget {
  final SortModel<ITEM> sortModel;
  final SortCriterion criterion;

  final bool enabled;
  final bool isDragging;

  final SortPanelStyle style;
  final SortIconBuilder? iconBuilder;

  const SortCriterionTile({
    super.key,
    required this.sortModel,
    required this.criterion,
    required this.style,
    this.enabled = true,
    this.isDragging = false,
    this.iconBuilder,
  });

  void _toggle() {
    sortModel.updateSortingCriterionByName(
      criterionName: criterion.criterionName,
      direction: criterion.nextDirection,
      moveToFirst: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = isDragging
        ? style.textStyle.copyWith(color: Colors.grey)
        : style.textStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(criterion.text, style: textStyle),
        SizedBox(width: style.iconSpacing),
        InkWell(
          onTap: enabled ? _toggle : null,
          child: (iconBuilder ?? defaultSortIcon)(
            context,
            criterion.direction,
            isDragging,
            style.sortIconSize,
            style.draggingColor,
          ),
        )
      ],
    );
  }
}
