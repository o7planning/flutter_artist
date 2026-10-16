import 'package:flutter/material.dart';

import '../../../../core/_core_/core.dart';
import '../../../../core/enums/_enums.dart';
import '_base_info_widget.dart';

class FormModeInfoWidget extends BaseInfoWidget {
  final BaseFormModel formModel;

  const FormModeInfoWidget({
    super.key,
    required this.formModel,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return "Show Form Model Inspector";
  }

  @override
  String getLabel() {
    return "Form Mode: ";
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  String getText() {
    return formModel.formMode.name.toString();
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: formModel.formMode.isNone
          ? null
          : (BuildContext context) {
              formModel.host.showDebugFormModelInspectorDialog();
            },
    );
  }
}
