part of '../../../core.dart';

/// Configuration for visual focus indicators rendered on active [_FocusableViewRegion]s.
class FocusIndicatorConfig {
  /// Whether visual focus indicators are enabled globally or for a specific region.
  final bool enabled;

  /// Whether the top-right indicator dot flashes when the region gains focus.
  final bool flashDotOnFocus;

  /// Whether the full-region tint overlay flashes when the region gains focus.
  final bool flashOverlayOnFocus;

  /// Whether the top-right indicator dot flashes when explicitly located (`Ctrl/Alt + L`).
  final bool flashDotOnLocate;

  /// Whether the full-region tint overlay flashes when explicitly located (`Ctrl/Alt + L`).
  final bool flashOverlayOnLocate;

  /// Custom color for the indicator dot. Defaults to [ColorScheme.primary].
  final Color? dotColor;

  /// Custom tint color for the full-region highlight overlay.
  /// Defaults to [dotColor] with 8% opacity.
  final Color? overlayColor;

  /// Custom border color for the full-region highlight overlay.
  /// Defaults to [dotColor] with 45% opacity.
  final Color? borderColor;

  /// Diameter of the top-right indicator dot in logical pixels.
  final double dotSize;

  /// Top and right offset for positioning the indicator dot.
  final double dotTopOffset;
  final double dotRightOffset;

  /// Border radius applied to the full-region highlight overlay.
  final double overlayBorderRadius;

  /// Total duration of the flash-and-fade animation cycle.
  final Duration duration;

  const FocusIndicatorConfig({
    this.enabled = true,
    this.flashDotOnFocus = true,
    this.flashOverlayOnFocus = false,
    this.flashDotOnLocate = true,
    this.flashOverlayOnLocate = true,
    this.dotColor,
    this.overlayColor,
    this.borderColor,
    this.dotSize = 8.0,
    this.dotTopOffset = 6.0,
    this.dotRightOffset = 6.0,
    this.overlayBorderRadius = 4.0,
    this.duration = const Duration(milliseconds: 950),
  });

  FocusIndicatorConfig copyWith({
    bool? enabled,
    bool? flashDotOnFocus,
    bool? flashOverlayOnFocus,
    bool? flashDotOnLocate,
    bool? flashOverlayOnLocate,
    Color? dotColor,
    Color? overlayColor,
    Color? borderColor,
    double? dotSize,
    double? dotTopOffset,
    double? dotRightOffset,
    double? overlayBorderRadius,
    Duration? duration,
  }) {
    return FocusIndicatorConfig(
      enabled: enabled ?? this.enabled,
      flashDotOnFocus: flashDotOnFocus ?? this.flashDotOnFocus,
      flashOverlayOnFocus: flashOverlayOnFocus ?? this.flashOverlayOnFocus,
      flashDotOnLocate: flashDotOnLocate ?? this.flashDotOnLocate,
      flashOverlayOnLocate: flashOverlayOnLocate ?? this.flashOverlayOnLocate,
      dotColor: dotColor ?? this.dotColor,
      overlayColor: overlayColor ?? this.overlayColor,
      borderColor: borderColor ?? this.borderColor,
      dotSize: dotSize ?? this.dotSize,
      dotTopOffset: dotTopOffset ?? this.dotTopOffset,
      dotRightOffset: dotRightOffset ?? this.dotRightOffset,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      duration: duration ?? this.duration,
    );
  }
}
