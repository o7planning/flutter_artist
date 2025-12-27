class DebugFormOptions {
  final bool showFormUIActive;
  final bool showFormEnable;
  final bool showFormDataState;
  final bool showFormMode;
  final bool showFormLoadCount;
  final bool showFormActivityCount;
  final bool showFormDirty;
  final bool showFormProps;

  const DebugFormOptions({
    this.showFormUIActive = true,
    this.showFormEnable = true,
    this.showFormDataState = true,
    this.showFormMode = true,
    this.showFormLoadCount = true,
    this.showFormActivityCount = true,
    this.showFormDirty = true,
    this.showFormProps = true,
  });

  const DebugFormOptions.custom({
    this.showFormUIActive = false,
    this.showFormEnable = false,
    this.showFormDataState = false,
    this.showFormMode = false,
    this.showFormLoadCount = false,
    this.showFormActivityCount = false,
    this.showFormDirty = false,
    this.showFormProps = false,
  });
}
