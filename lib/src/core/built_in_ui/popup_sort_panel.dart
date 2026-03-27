import 'package:flutter/material.dart';
import 'package:flutter_artist_theme/flutter_artist_theme.dart';

import '../_core_/core.dart';
import '_menu_item.dart';
import '_sorting_options.dart';
import '_tile.dart';
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

    final tokens = context.faTokens;
    final theme = Theme.of(context);

    return PopupMenuButton<void>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      elevation: tokens.shortcut.elevation > 0 ? tokens.shortcut.elevation : 8,
      color: tokens.shortcut.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
        side: tokens.shortcut.border,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.shortcut.borderRadius),
        onTap: null,
        hoverColor: theme.primaryColor.withValues(alpha: 0.08),
        child: Container(
          height: style.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: style.menuDecoration ??
              BoxDecoration(
                color: tokens.shortcut.surfaceColor,
                border: Border.fromBorderSide(tokens.shortcut.border),
                borderRadius:
                    BorderRadius.circular(tokens.shortcut.borderRadius),
                boxShadow: tokens.shortcut.cardShadows,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buildTriggerContent(context, activeCriterion, hasActiveSort),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 20,
                color: hasActiveSort
                    ? theme.primaryColor
                    : tokens.shortcut.onSurfaceColor.withValues(alpha: 0.5),
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
