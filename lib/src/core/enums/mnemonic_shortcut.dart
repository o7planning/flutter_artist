part of '_enums.dart';

/// Centralized catalog of standard mnemonic shortcuts for enterprise operations
/// across [Block], [Scalar], [FilterModel], [Task], and [Prozess] control bars.
enum MnemonicShortcut {
  // --- Standard Navigation & CRUD ---
  back(MnemonicModifier.alt, 'B'),
  create(MnemonicModifier.alt, 'C'),
  edit(MnemonicModifier.alt, 'E'),
  delete(MnemonicModifier.alt, 'D'),
  save(MnemonicModifier.alt, 'S'),
  reset(MnemonicModifier.alt, 'U'), // Undo / Reset changes
  refresh(MnemonicModifier.alt, 'R'),
  query(MnemonicModifier.alt, 'Q'),

  // --- Workflow, Stage & Task Operations ---
  submit(MnemonicModifier.alt, 'S'),
  restart(MnemonicModifier.alt, 'R'),
  restartAll(MnemonicModifier.altShift, 'R'), // Restart entire Prozess
  moveToNextStage(MnemonicModifier.alt, 'N'),
  moveToPreviousStage(MnemonicModifier.alt, 'P'),
  cancel(MnemonicModifier.alt, 'X'),

  // --- Developer & Inspector Tools ---
  debugFilter(MnemonicModifier.alt, '1'),
  debugForm(MnemonicModifier.alt, '2'),
  debugInspector(MnemonicModifier.alt, '3');

  /// The modifier keys (e.g., [MnemonicModifier.alt], [MnemonicModifier.altShift])
  /// required to activate this shortcut.
  final MnemonicModifier modifier;

  /// The single uppercase alphanumeric character (A-Z, 0-9) for this shortcut.
  final String charKey;

  const MnemonicShortcut(this.modifier, this.charKey);

  /// Returns the platform-aware shortcut representation (e.g., `"Alt + S"` or `"Option + S"`).
  String get shortcutLabel => '${modifier.label} + $charKey';

  /// Formats a base tooltip with the shortcut suffix, e.g., `"Save (Alt + S)"`.
  String formatTooltip(String baseTooltip) => '$baseTooltip ($shortcutLabel)';
}
