part of '../../../core.dart';

abstract class FormViewConfig {
  bool get circularFocusTraversal => false;

  const FormViewConfig();
}

class InternalFormViewConfig extends FormViewConfig {
  const InternalFormViewConfig();
}
