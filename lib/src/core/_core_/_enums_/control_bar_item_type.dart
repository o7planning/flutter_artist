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
  debugFilterCriteria(MnemonicShortcut.debugFilterCriteria),
  debugFormModel(MnemonicShortcut.debugFormModel);

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
  debugFilterCriteria(MnemonicShortcut.debugFilterCriteria);

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
  debugFilterModel(MnemonicShortcut.debugFilterModel),
  ;

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
  reset(MnemonicShortcut.reset),
  divider(null),
  debugFormModel(MnemonicShortcut.debugFormModel),
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
  debugViewingStageFormModel(MnemonicShortcut.debugFormModel),
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
