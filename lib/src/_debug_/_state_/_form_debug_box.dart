part of '../../../flutter_artist.dart';

class _FormDebugBox extends _BaseDebugBox {
  final FormModel formModel;
  final FormDebugOptions options;

  const _FormDebugBox({
    super.key,
    required this.formModel,
    required this.options,
  });

  @override
  List<dialogs.IconLabelText> getChildIconLabelTexts() {
    return [
      if (options.showFormUIActive)
        IconLabelText(
          label: "Form UI Active?: ",
          text:
              "${formModel.hasActiveUIComponent()}/${formModel.loadTimeUIActive}*",
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
          text: formModel.formDataState.name.toString(),
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
  }
}
