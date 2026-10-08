import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';

import '../../../../core/enums/_enums.dart';
import '../../../class_def/_class_def_views.dart';
import '../../../dialog/class_definition_inspector_dialog.dart';
import '_base_info_widget.dart';

class ClassDefViewableInfoWidget extends BaseInfoWidget {
  final ClassDefViewable classDefViewable;

  const ClassDefViewableInfoWidget({
    super.key,
    required this.classDefViewable,
    required super.labelStyle,
    required super.textStyle,
  });

  @override
  String? getButtonTooltip() {
    return null;
  }

  @override
  String getLabel() {
    return "Class: ";
  }

  @override
  String getText() {
    return getClassNameWithoutGenerics(classDefViewable);
  }

  @override
  String? getLeftTooltip() {
    return null;
  }

  @override
  ButtonFunction? getButtonFunction() {
    return ButtonFunction(
      btnType: DebugBtnType.success,
      onPressed: (BuildContext context) {
        _showClassDefInfoDialog(context);
      },
    );
  }

  void _showClassDefInfoDialog(BuildContext context) {
    ClassDefinitionInspectorDialog.show(
      context: context,
      title: 'Class Definition View',
      targetObject: classDefViewable,
    );
  }
}
