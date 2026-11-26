part of '../_built_in_ui.dart';

/// Column definition for [DefaultLovView].
///
/// Use the default constructor for plain text cells via [valueGetter],
/// or [LovColumn.custom] to render arbitrary widgets (badges, icons, avatars).
class LovColumn<ITEM> {
  final String title;

  /// Extracts a plain display string from [item].
  final String Function(ITEM item)? valueGetter;

  /// Builds a custom widget cell for [item]. Takes precedence over [valueGetter].
  final Widget Function(BuildContext context, ITEM item)? cellBuilder;

  /// Fixed column width in logical pixels. When `null`, [flex] is used instead.
  final double? width;

  /// Flexible width weight used when [width] is `null`.
  final int flex;

  final AlignmentGeometry alignment;
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;

  const LovColumn({
    required this.title,
    required String Function(ITEM item) this.valueGetter,
    this.width,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
    this.headerStyle,
    this.cellStyle,
  }) : cellBuilder = null;

  const LovColumn.custom({
    required this.title,
    required Widget Function(BuildContext context, ITEM item) this.cellBuilder,
    this.width,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
    this.headerStyle,
  })
      : valueGetter = null,
        cellStyle = null;
}
