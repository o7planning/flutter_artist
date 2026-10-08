import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '../../../dialog/_process_stages_inspector_dialog.dart';
import '_base_info_widget.dart';

class StagesInfoWidget extends BaseInfoWidget {
  final Prozess prozess;

  const StagesInfoWidget({
    super.key,
    required this.prozess,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return null;
  }

  @override
  String getLabel() {
    return "Stage Count: ";
  }

  @override
  String getText() {
    return "${prozess.orderedStages.length}";
  }

  @override
  String? getLeftTooltip() {
    return "";
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: (BuildContext context) {
        ProzessStagesInspectorDialog.show(
          context: context,
          prozess: prozess,
        );
      },
    );
  }
}
