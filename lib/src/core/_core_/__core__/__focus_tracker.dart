part of '../core.dart';

/// Global reactive broadcaster tracking the currently focused [ActiveFocusRegion].
///
/// Third-party UI shells (such as `ApplicationStatusBar` in `flutter_artist_face`)
/// can listen to [activeRegionListenable] via [ValueListenableBuilder] without
/// introducing coupling back into the core framework.
class FocusTracker {
  final ValueNotifier<ActiveFocusRegion?> _activeRegion =
      ValueNotifier<ActiveFocusRegion?>(null);

  /// Read-only listenable emitting updates whenever the active focus region changes.
  ValueListenable<ActiveFocusRegion?> get activeRegionListenable =>
      _activeRegion;

  /// Returns the currently focused region, or `null` if focus resides outside
  /// FlutterArtist-managed regions.
  ActiveFocusRegion? get currentRegion => _activeRegion.value;

  /// Marks [region] as the active focused region.
  void notifyRegionFocused(ActiveFocusRegion region) {
    if (_activeRegion.value != region) {
      _activeRegion.value = region;
    }
  }

  /// Clears the active region only if [region] is still the currently tracked one.
  ///
  /// This prevents race conditions where a newly focused region updates first
  /// and an outgoing region's unfocus callback arrives immediately afterward.
  void notifyRegionUnfocused(ActiveFocusRegion region) {
    if (_activeRegion.value == region) {
      _activeRegion.value = null;
    }
  }

  /// Resets the tracked focus state (e.g., upon user logout or full shell reset).
  void clear() {
    _activeRegion.value = null;
  }
}
