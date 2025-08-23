import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabThemeUtils {
  static TabbedViewThemeData getTabbedViewThemeData() {
    TabbedViewThemeData themeData = TabbedViewThemeData.classic();
    final borderSide = BorderSide(color: Colors.grey, width: 0.7);
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
      ..decoration = boxDecoTabSelected
      ..fontColor = Colors.indigo;
    themeData.tab
      ..hoverButtonColor = Colors.indigo.withAlpha(40)
      ..highlightedStatus.decoration = boxDecoTabSelected
      ..selectedStatus = selectedStatus
      ..decoration = boxDecoTabDeselected;
    //
    themeData.tabsArea
      ..border = Border(bottom: BorderSide(color: Colors.transparent, width: 0))
      ..gapBottomBorder = borderSide
      ..initialGap = 20
      ..middleGap = 5
      ..minimalFinalGap = 2;
    //
    themeData.contentArea
      ..decoration = boxDecoContent
      ..padding = EdgeInsets.all(5);
    //
    return themeData;
  }
}
