part of '../_fa_core.dart';

class FormModelConfig {
  final AutovalidateMode autovalidateMode;

  const FormModelConfig({
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  FormModelConfig copy() {
    return FormModelConfig(autovalidateMode: autovalidateMode);
  }
}
