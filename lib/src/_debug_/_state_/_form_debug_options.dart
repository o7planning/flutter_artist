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

  const FormDebugOptions.custom({
    this.showFormUIActive = false,
    this.showFormEnable = false,
    this.showFormDataState = false,
    this.showFormMode = false,
    this.showFormLoadCount = false,
    this.showFormActivityCount = false,
    this.showFormDirty = false,
  });
}
