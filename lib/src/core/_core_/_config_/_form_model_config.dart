part of '../core.dart';

class FormModelConfig {
  final AutovalidateMode autovalidateMode;

  const FormModelConfig({
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  FormModelConfig copy({
    AutovalidateMode? autovalidateMode,
  }) {
    return FormModelConfig(
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
    );
  }
}