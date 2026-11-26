part of '../../core.dart';

/// Visual and dialog layout configuration for [FormBuilderLovField].
class LovFieldStyle {
  // ---------------------------------------------------------------------------
  // Field decoration & appearance
  // ---------------------------------------------------------------------------

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final IconData triggerIconData;
  final String triggerTooltip;
  final bool showClearButton;
  final IconData clearIconData;
  final String clearTooltip;

  // Multi-selection display options
  final LovMultiDisplayMode multiDisplayMode;
  final String multiSeparator;
  final double chipSpacing;
  final double chipRunSpacing;

  // ---------------------------------------------------------------------------
  // Integrated FaDialog layout & button labels
  // ---------------------------------------------------------------------------

  final String? dialogTitle;
  final double dialogWidth;
  final double dialogHeight;
  final EdgeInsets dialogContentPadding;
  final String confirmButtonText;
  final String cancelButtonText;
  final String clearSelectionButtonText;

  const LovFieldStyle({
    this.labelText,
    this.hintText,
    this.helperText,
    this.decoration,
    this.textStyle,
    this.triggerIconData = Icons.search,
    this.triggerTooltip = 'Open List of Values (F9)',
    this.showClearButton = true,
    this.clearIconData = Icons.clear,
    this.clearTooltip = 'Clear',
    this.multiDisplayMode = LovMultiDisplayMode.chips,
    this.multiSeparator = ', ',
    this.chipSpacing = 4,
    this.chipRunSpacing = 4,
    this.dialogTitle,
    this.dialogWidth = 620,
    this.dialogHeight = 420,
    this.dialogContentPadding = const EdgeInsets.all(8),
    this.confirmButtonText = 'OK',
    this.cancelButtonText = 'Cancel',
    this.clearSelectionButtonText = 'Clear',
  });
}
