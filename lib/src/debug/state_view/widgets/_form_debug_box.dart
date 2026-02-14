import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';
import '../options/_debug_form_options.dart';
import '_debug_box.dart';

class FormDebugBox extends BaseDebugBox {
  final FormModel formModel;
  final DebugFormOptions options;

  const FormDebugBox({
    super.key,
    required this.formModel,
    required this.options,
  });

  @override
  List<Widget> getChildIconLabelTexts() {
    FormModelStructure structure = formModel.formPropsStructure;
    List<MultiOptFormPropModel> optProps = structure.allMultiOptProps;
    //
    List<Widget> list1 = [
      if (options.showFormUIActive)
        IconLabelText(
          label: "Form UI Active?: ",
          text:
              "${formModel.ui.hasActiveUiComponent()}/${formModel.loadTimeUIActive}*",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      if (options.showFormEnable)
        IconLabelText(
          label: "Form Enable?: ",
          text: "${formModel.isEnabled()}",
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
      if (options.showFormDataState)
        IconLabelText(
          label: "Form State: ",
          text: formModel.dataState.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showFormMode)
        IconLabelText(
          label: "Form Mode: ",
          text: formModel.formMode.name.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showFormLoadCount)
        IconLabelText(
          label: "Form Load Count: ",
          text: formModel.loadCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showFormActivityCount)
        IconLabelText(
          label: "Form Activity Count: ",
          text: formModel.formActivityCount.toString(),
          labelStyle: labelStyle,
          textStyle: textStyle,
        ),
      if (options.showFormDirty)
        IconLabelText(
          label: "Form Dirty: ",
          text: formModel.isDirty().toString(),
          labelStyle: labelStyle0,
          textStyle: textStyle0,
        ),
    ];

    List<Widget> list2 = [
      if (options.showFormProps && optProps.isNotEmpty)
        ...optProps.map(
          (optProp) => IconLabelText(
            label: "Load Count (${optProp.propName}): ",
            text: optProp.loadCount.toString(),
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
        ),
    ];
    return [
      ...list1,
      if (options.showFormProps && optProps.isNotEmpty && list1.isNotEmpty)
        Divider(),
      if (options.showFormProps && optProps.isNotEmpty) ...list2,
    ];
  }
}
