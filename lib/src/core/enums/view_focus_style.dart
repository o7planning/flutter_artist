part of '_enums.dart';

/// Defines how a focusable view region visually indicates that it currently holds keyboard focus.
enum ViewFocusStyle {
  /// No visual focus indicator is rendered.
  none,

  /// Renders a sleek vertical accent bar along the left edge (default).
  /// Works seamlessly with both ListView and bordered tables like FaDaviTable without double-bordering.
  leftAccentBar,

  /// Renders a subtle translucent tint over the surface when focused.
  subtleTint,

  /// Renders a thin border around the entire region.
  outlineBorder,
}
