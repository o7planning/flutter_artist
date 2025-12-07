import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabThemeUtils {
  static TabbedViewThemeData getTabbedViewThemeData() {
    // .classic (borderColor: Colors.grey)
    TabbedViewThemeData themeData = TabbedViewThemeData.underline();
    final borderSide = BorderSide(color: Colors.grey, width: 0.7);
    final borderSideSelected = BorderSide(color: Colors.grey, width: 2);
    final borderSideNone = BorderSide(color: Colors.grey, width: 0);

    final borderSideTransparent =
        BorderSide(color: Colors.transparent, width: 0.5);
    //
    final boxDecoTabDeselected = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSide,
      ),
    );
    final boxDecoTabSelected = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        top: borderSide,
        bottom: borderSideTransparent,
      ),
    );
    final boxDecoContent = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        left: borderSide,
        right: borderSide,
        bottom: borderSide,
        top: borderSideTransparent,
      ),
    );
    //
    TabStatusThemeData selectedStatus = TabStatusThemeData()
      ..buttonBackground = boxDecoTabSelected
      ..fontColor = Colors.indigo;
    themeData.tab
      ..decorationBuilder = ({
        required TabStatus status,
        required TabBarPosition tabBarPosition,
      }) {
        return TabDecoration(
          border: Border(
            left: borderSide,
            right: borderSide,
            top: borderSide,
            bottom: status == TabStatus.selected
                ? borderSideSelected
                : borderSideNone,
          ),
        );
      }
      ..hoveredButtonColor = Colors.indigo.withAlpha(40)
      ..hoveredStatus.hoveredButtonBackground = boxDecoTabSelected
      ..selectedStatus = selectedStatus
      ..buttonsOffset = 2;
    //
    themeData.tabsArea
      ..border = BorderSide(color: Colors.transparent, width: 1)
      ..initialGap = 10
      ..middleGap = 3
      ..minimalFinalGap = 2;
    //
    themeData.contentArea
      ..padding = EdgeInsets.all(5)
      ..border = borderSide;
    //
    return themeData;
  }
}
