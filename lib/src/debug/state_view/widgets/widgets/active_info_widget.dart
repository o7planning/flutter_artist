import 'package:flutter/material.dart';
import 'package:flutter_artist/src/core/enums/debug_btn_type.dart';

import '../../../../core/enums/active_element_type.dart';
import '_base_info_widget.dart';

class ActiveInfoWidget extends BaseInfoWidget {
  final ActiveElementType activeElementType;
  final String? activeUiComponentName;
  final String? xActiveUiComponentName;
  final Function() checkAgain;

  const ActiveInfoWidget({
    super.key,
    required this.activeElementType,
    required this.activeUiComponentName,
    required this.xActiveUiComponentName,
    required super.labelStyle,
    required super.textStyle,
    required this.checkAgain,
  });

  @override
  String? getButtonTooltip() {
    return null;
  }

  @override
  String getLabel() {
    return "UI A/XActive? (${activeElementType.shortInf()}): ";
  }

  @override
  String getText() {
    return "${activeUiComponentName != null} / ${xActiveUiComponentName != null}";
  }

  @override
  String? getLeftTooltip() {
    return activeUiComponentName != null
        ? "Active UI: $activeUiComponentName"
        : xActiveUiComponentName != null
            ? "Active UI: $xActiveUiComponentName"
            : "";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
        btnType: DebugBtnType.success,
        onPressed: (BuildContext context) {
          checkAgain();
        });
  }
}
