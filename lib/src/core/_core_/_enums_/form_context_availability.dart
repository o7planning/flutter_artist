part of '_enums.dart';

/// Specifies how a [Block] operation determines whether a form context is
/// available for synchronizing its associated [BlockFormModel].
enum FormContextAvailability {
  /// Automatically detects whether any visible view currently provides a form
  /// context (such as a visible [BlockFormView] or a view configured with
  /// [BlockViewContext.form]).
  auto,

  /// Treats the operation as if a form context is actively available on screen,
  /// ensuring the [BlockFormModel] (if configured) is synchronized even when no
  /// visible view currently provides [BlockViewContext.form] (e.g., before
  /// opening an edit dialog or screen).
  assumeAvailable,
}
