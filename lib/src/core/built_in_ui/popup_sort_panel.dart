import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';

import '../_core_/core.dart';
import '_menu_item.dart';
import '_sort_panel_helper.dart';
import '_sorting_options.dart';
import '_style.dart';
import 'popup_sort_panel_style.dart';

/// A sort panel that opens a stateful popup menu for selecting criteria.
class PopupSortPanel<ITEM extends Object> extends SortPanel<ITEM>
    with SortPanelMixin {
  final PopupSortPanelStyle style;

  const PopupSortPanel({
    super.key,
    required super.sortModel,
    this.style = const PopupSortPanelStyle(),
  });

  @override
  Widget buildContent(BuildContext context) {
    final activeCriterion = sortModel.findFirstCriterionHasDirection();
    final hasActiveSort = activeCriterion != null;

    final tokens = context.faTheme.tokens;

    return PopupMenuButton<void>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      elevation: tokens.elevation.defaultValue,
      color: SortPanelHelper.getBackgroundColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius.sm),
        side: SortPanelHelper.getBorder(context),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.radius.sm),
        onTap: null,
        hoverColor:
            SortPanelHelper.getTextColor(context, true).withValues(alpha: 0.08),
        child: Container(
          height: style.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: style.menuDecoration ??
              BoxDecoration(
                color: SortPanelHelper.getBackgroundColor(context),
                border:
                    Border.fromBorderSide(SortPanelHelper.getBorder(context)),
                borderRadius: BorderRadius.circular(tokens.radius.sm),
                boxShadow: context.faTheme.shadow.popup,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildTriggerContent(context, activeCriterion, hasActiveSort),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: SortPanelHelper.getIconColor(context, hasActiveSort),
              ),
            ],
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sortModel.criteria
                .map((c) => SortMenuItem(
                      criterion: c,
                      sortModel: sortModel,
                      style: style,
                      iconBuilder: style.iconBuilder,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTriggerContent(
      BuildContext context, SortCriterion? active, bool isActive) {
    final List<Widget> children = [];
    final iconWidget = (style.iconBuilder ?? defaultSortIcon)(
        context, active?.direction, false, style.sortIconSize, null);

    final textWidget = Text(active?.text ?? "Sort",
        style: style.getTextStyle(context, isActive));

    if (style.textPosition == PopupTextPosition.left) {
      children.addAll([
        Flexible(child: textWidget),
        SizedBox(width: style.textIconSpacing),
        iconWidget
      ]);
    } else if (style.textPosition == PopupTextPosition.right) {
      children.addAll([
        iconWidget,
        SizedBox(width: style.textIconSpacing),
        Flexible(child: textWidget)
      ]);
    } else {
      children.add(iconWidget);
    }
    return children;
  }
}
