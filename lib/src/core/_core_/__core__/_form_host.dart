part of '../core.dart';

abstract interface class FormHost {
  BaseFormModel? get formModel;

  /// Returns whether the host's underlying state is ready for the form.
  ///
  /// Note: This represents a necessary condition (condition needed),
  /// but not a sufficient condition, for the form to be enabled and interactive.
  bool isStateReadyForForm();
}
