import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/data_debug_dialog.dart';
import '_base_info_widget.dart';

class ProzessContextDataInfoWidget extends BaseInfoWidget {
  final Prozess prozess;

  const ProzessContextDataInfoWidget({
    super.key,
    required this.prozess,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Prozess Context Data";
  }

  @override
  String getLabel() {
    return "Has Context Data?: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    return prozess.prozessContextData != null ? "true" : "false";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: prozess.prozessContextData == null
          ? null
          : (BuildContext context) {
        DataDebugDialog.show(
          context: context,
          title: '',
          targetObject: prozess.prozessContextData!,
        );
      },
    );
  }
}
