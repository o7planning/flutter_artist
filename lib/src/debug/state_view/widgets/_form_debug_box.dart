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
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    FormModelStructure structure = formModel.formPropsStructure;
    List<MultiOptFormPropModel> optProps = structure.allMultiOptProps;
    //
    List<Widget> list1 = [
      if (options.showFormUiActive)
        IconLabelText(
          label: "Form UI Active?: ",
          text:
              "${formModel.ui.hasActiveUiComponent()}/${formModel.loadTimeUiActive}*",
          labelStyle: getLabelStyle0(context),
          textStyle: getTextStyle0(context),
        ),
      if (options.showFormEnable)
        IconLabelText(
          label: "Form Enable?: ",
          text: "${formModel.isEnabled()}",
          labelStyle: getLabelStyle0(context),
          textStyle: getTextStyle0(context),
        ),
      if (options.showFormDataState)
        IconLabelText(
          label: "Form State: ",
          text: formModel.dataState.name.toString(),
          labelStyle: getLabelStyle(context),
          textStyle: getTextStyle(context),
        ),
      if (options.showFormMode)
        IconLabelText(
          label: "Form Mode: ",
          text: formModel.formMode.name.toString(),
          labelStyle: getLabelStyle(context),
          textStyle: getTextStyle(context),
        ),
      if (options.showFormLoadCount)
        IconLabelText(
          label: "Form Load Count: ",
          text: formModel.loadCount.toString(),
          labelStyle: getLabelStyle(context),
          textStyle: getTextStyle(context),
        ),
      if (options.showFormActivityCount)
        IconLabelText(
          label: "Form Activity Count: ",
          text: formModel.formActivityCount.toString(),
          labelStyle: getLabelStyle(context),
          textStyle: getTextStyle(context),
        ),
      if (options.showFormDirty)
        IconLabelText(
          label: "Form Dirty: ",
          text: formModel.isDirty().toString(),
          labelStyle: getLabelStyle0(context),
          textStyle: getTextStyle0(context),
        ),
    ];

    List<Widget> list2 = [
      if (options.showFormProps && optProps.isNotEmpty)
        ...optProps.map(
          (optProp) => IconLabelText(
            label: "Load Count (${optProp.propName}): ",
            text: optProp.loadCount.toString(),
            labelStyle: getLabelStyle0(context),
            textStyle: getTextStyle0(context),
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
