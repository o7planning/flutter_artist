part of '../../../flutter_artist.dart';

class FormDebugOptions {
  final bool showFormUIActive;
  final bool showFormEnable;
  final bool showFormDataState;
  final bool showFormMode;
  final bool showFormLoadCount;
  final bool showFormActivityCount;
  final bool showFormDirty;

  const FormDebugOptions({
    this.showFormUIActive = true,
    this.showFormEnable = true,
    this.showFormDataState = true,
    this.showFormMode = true,
    this.showFormLoadCount = true,
    this.showFormActivityCount = true,
    this.showFormDirty = true,
  });
}
