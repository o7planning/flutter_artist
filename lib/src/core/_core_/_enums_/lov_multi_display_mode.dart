part of '_enums.dart';

/// Determines how selected items are displayed inside [FormBuilderLovField]
/// when [LovSelectionMode.multiple] is active.
enum LovMultiDisplayMode {
  /// Renders each selected item as a compact chip inside a [Wrap].
  chips,

  /// Renders selected items as a single joined text string (e.g. "A, B, C").
  joinedText,
}
