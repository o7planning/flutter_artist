import 'package:flutter/material.dart';
import 'package:flutter_artist_styles/flutter_artist_styles.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabThemeUtils {
  static TabbedViewThemeData getTabbedViewThemeData(BuildContext context) {
    // 2. Map structural layout canvas and boundary parameters onto exact token milestones
    final Color contentAreaColor = context.faColors.surface.standard;
    final Color borderColor = context.faColors.stroke.subtle;
    final Color selectedTabColor = context.faColors.stroke.strong;

    final borderSide = BorderSide(color: borderColor, width: 1);
    final borderSideSelected = BorderSide(color: selectedTabColor, width: 2.0);
    final borderSideNone = const BorderSide(
      color: Colors.transparent,
      width: 0,
    );

    TabbedViewThemeData themeData = TabbedViewThemeData.underline();

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
      ..selectedStatus = TabStatusThemeData(
        fontColor: getTabTextColor(context, TabStatus.selected),
      )
      ..hoveredStatus = TabStatusThemeData(
        fontColor: getTabTextColor(context, TabStatus.hovered),
      );

    themeData.tab
      ..selectedStatus = selectedStatus
      ..hoveredStatus = hoveredStatus
      ..decorationBuilder = ({
        required TabStyleContext styleContext,
        required TabBarPosition tabBarPosition,
      }) {
        return TabDecoration(
          color: styleContext.status == TabStatus.selected
              ? contentAreaColor
              : Colors.transparent,
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
      ..color = Colors.transparent
      ..initialGap = 0
      ..middleGap = 0
      ..minimalFinalGap = 0;

    themeData.contentArea
      ..color = contentAreaColor
      ..padding = const EdgeInsets.all(8)
      ..border = borderSide;

    return themeData;
  }

  static Color getTabIconColor(BuildContext context, TabStatus tabStatus) {
    return getTabTextColor(context, tabStatus);
  }

  static Color getTabTextColor(BuildContext context, TabStatus status) {
    switch (status) {
      case TabStatus.selected:
        // Anchored core typography text value inside selected interaction contexts
        return context.faColors.ink.primary;

      case TabStatus.hovered:
        // Supporting accompaniment ink for focused hover states
        return context.faColors.ink.secondary;

      case TabStatus.unselected:
        // Low-contrast regular typography for idle unselected viewports
        return context.faColors.ink.tertiary;
    }
  }
}
