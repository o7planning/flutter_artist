part of '_enums.dart';

/// Defines whether clicking inside a focusable view region with a mouse or
/// pointer should transfer keyboard focus to that region.
enum ViewMouseFocusPolicy {
  /// Clicking inside the region interacts with items (e.g., triggering row
  /// selection and data refresh in a single click) without stealing keyboard
  /// focus from an active form or input field.
  ///
  /// To focus the region for keyboard navigation (such as Up/Down arrow keys),
  /// the user must explicitly switch regions via keyboard shortcuts (e.g., `Ctrl + Tab`).
  strictNavigationOnly,

  /// Clicking anywhere inside the region immediately transfers keyboard focus
  /// to the region and displays its visual focus indicator on the first click.
  clickToFocus,
}