part of '_enums.dart';

/// Defines the standard control bar item types available for a [BlockControlBar].
enum BlockControlBarItemType {
  back(MnemonicShortcut.back),
  refresh(MnemonicShortcut.refresh),
  query(MnemonicShortcut.query),
  create(MnemonicShortcut.create),
  edit(MnemonicShortcut.edit),
  save(MnemonicShortcut.save),
  delete(MnemonicShortcut.delete),
  reset(MnemonicShortcut.reset),
  custom(null),
  divider(null),
  debugFilter(MnemonicShortcut.debugFilter),
  debugForm(MnemonicShortcut.debugForm);

  /// The default mnemonic shortcut associated with this control bar item, if any.
  final MnemonicShortcut? mnemonicShortcut;

  const BlockControlBarItemType(this.mnemonicShortcut);

  String formatTooltip(String baseTooltip) {
    return mnemonicShortcut == null
        ? baseTooltip
        : mnemonicShortcut!.formatTooltip(baseTooltip);
  }
}

/// Defines the standard control bar item types available for a [ScalarControlBar].
enum ScalarControlBarItemType {
  back(MnemonicShortcut.back),
  query(MnemonicShortcut.query),
  custom(null),
  divider(null),
  debugFilter(MnemonicShortcut.debugFilter);

  /// The default mnemonic shortcut associated with this control bar item, if any.
  final MnemonicShortcut? mnemonicShortcut;

  const ScalarControlBarItemType(this.mnemonicShortcut);

  String formatTooltip(String baseTooltip) {
    return mnemonicShortcut == null
        ? baseTooltip
        : mnemonicShortcut!.formatTooltip(baseTooltip);
  }
}

/// Defines the standard control bar item types available for a [FilterControlBar].
enum FilterControlBarItemType {
  back(MnemonicShortcut.back),
  divider(null),
  custom(null),
  debugFilter(MnemonicShortcut.debugFilter);

  /// The default mnemonic shortcut associated with this control bar item, if any.
  final MnemonicShortcut? mnemonicShortcut;

  const FilterControlBarItemType(this.mnemonicShortcut);

  String formatTooltip(String baseTooltip) {
    return mnemonicShortcut == null
        ? baseTooltip
        : mnemonicShortcut!.formatTooltip(baseTooltip);
  }
}

/// Defines the standard control bar item types available for a [TaskControlBar].
enum TaskControlBarItemType {
  back(MnemonicShortcut.back),
  restart(MnemonicShortcut.restart),
  submit(MnemonicShortcut.submit),
  divider(null),
  debugForm(MnemonicShortcut.debugForm),
  custom(null);

  /// The default mnemonic shortcut associated with this control bar item, if any.
  final MnemonicShortcut? mnemonicShortcut;

  const TaskControlBarItemType(this.mnemonicShortcut);

  String formatTooltip(String baseTooltip) {
    return mnemonicShortcut == null
        ? baseTooltip
        : mnemonicShortcut!.formatTooltip(baseTooltip);
  }
}

/// Defines the standard control bar item types available for a [ProzessControlBar].
enum ProzessControlBarItemType {
  back(MnemonicShortcut.back),
  cancel(MnemonicShortcut.cancel),
  restartProzess(MnemonicShortcut.restartAll),
  restartViewingStage(MnemonicShortcut.restart),
  submitViewingStage(MnemonicShortcut.submit),
  debugInspector(MnemonicShortcut.debugInspector),
  debugViewingStageForm(MnemonicShortcut.debugForm),
  divider(null),
  moveToNextStage(MnemonicShortcut.moveToNextStage),
  moveToPreviousStage(MnemonicShortcut.moveToPreviousStage),
  custom(null);

  /// The default mnemonic shortcut associated with this control bar item, if any.
  final MnemonicShortcut? mnemonicShortcut;

  const ProzessControlBarItemType(this.mnemonicShortcut);

  String formatTooltip(String baseTooltip) {
    return mnemonicShortcut == null
        ? baseTooltip
        : mnemonicShortcut!.formatTooltip(baseTooltip);
  }
}
