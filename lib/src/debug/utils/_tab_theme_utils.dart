import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabThemeUtils {
  static TabbedViewThemeData getTabbedViewThemeData(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color contentAreaColor = colorScheme.surfaceContainer;
    final Color tabsAreaColor = colorScheme.surfaceContainerLow;

    final Color borderColor = theme.dividerColor;
    final Color selectedTabColor = colorScheme.primary;

    final borderSide = BorderSide(color: borderColor, width: 0.7);
    final borderSideSelected = BorderSide(color: selectedTabColor, width: 2.0);
    final borderSideNone =
        const BorderSide(color: Colors.transparent, width: 0);

    final themeData = TabbedViewThemeData.underline();

    final boxDecoTabSelected = BoxDecoration(
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSideSelected,
      ),
    );

    final selectedStatus = TabStatusThemeData()
      ..fontColor = getTabTextColor(context, TabStatus.selected)
      ..buttonBackground = boxDecoTabSelected;

    final hoveredStatus = TabStatusThemeData()
      ..fontColor = getTabTextColor(context, TabStatus.hovered)
      ..buttonBackground = boxDecoTabSelected;

    themeData.tab
      ..textStyle = TextStyle(
        fontSize: 13,
        color: getTabTextColor(context, TabStatus.unselected),
      )
      ..selectedStatus = selectedStatus
      ..hoveredStatus = hoveredStatus
      ..decorationBuilder = ({
        required TabStyleContext styleContext,
        required TabBarPosition tabBarPosition,
      }) {
        Color backgroundColor;

        if (styleContext.status == TabStatus.selected) {
          backgroundColor = colorScheme.surface;
        } else if (styleContext.status == TabStatus.hovered) {
          backgroundColor = colorScheme.primary.withValues(alpha: 0.06);
        } else {
          backgroundColor = Colors.transparent;
        }

        return TabDecoration(
          color: backgroundColor,
          border: Border(
            left: borderSide,
            right: borderSide,
            top: borderSide,
            bottom: styleContext.status == TabStatus.selected
                ? borderSideSelected
                : borderSideNone,
          ),
        );
      }
      ..padding = const EdgeInsets.symmetric(vertical: 3, horizontal: 10)
      ..buttonsOffset = 0;

    themeData.tabsArea
      ..border = const BorderSide(color: Colors.transparent, width: 1)
      ..color = tabsAreaColor
      ..initialGap = 0
      ..middleGap = 0
      ..minimalFinalGap = 0;

    themeData.contentArea
      ..color = contentAreaColor
      ..padding = const EdgeInsets.all(8)
      ..border = borderSide;

    return themeData;
  }

  static Widget buildTabLeading(
      BuildContext context, TabStatus status, IconData iconData, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color color;
    FontWeight fontWeight;

    if (status == TabStatus.selected) {
      color = colorScheme.primary;
      fontWeight = FontWeight.bold;
    } else if (status == TabStatus.hovered) {
      color = colorScheme.onSurface;
      fontWeight = FontWeight.w600;
    } else {
      color = colorScheme.onSurface.withValues(alpha: 0.6);
      fontWeight = FontWeight.w500;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  static Color getTabIconColor(BuildContext context, TabStatus tabStatus) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (tabStatus) {
      case TabStatus.selected:
        return colorScheme.primary;

      case TabStatus.hovered:
        return colorScheme.onSurface;

      case TabStatus.unselected:
      default:
        return colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  static Color getTabTextColor(BuildContext context, TabStatus status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (status) {
      case TabStatus.selected:
        return colorScheme.primary;

      case TabStatus.hovered:
        return colorScheme.onSurface;

      case TabStatus.unselected:
      default:
        return colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}
