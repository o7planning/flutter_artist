part of '../../core.dart';

/// Internal registry keeping track of all mounted [_FocusableViewRegionState]
/// instances for programmatic region traversal (e.g., `Ctrl + \``) and
/// post-execution focus targeting.
class _RegionDispatcher {
  static final List<_FocusableViewRegionState> _regions = [];

  static void register(_FocusableViewRegionState region) {
    if (!_regions.contains(region)) {
      _regions.add(region);
    }
  }

  static void unregister(_FocusableViewRegionState region) {
    _regions.remove(region);
  }

  static List<_FocusableViewRegionState> getActiveRouteRegions() {
    return _regions.where((region) => region.isEligibleForTraversal).toList();
  }

  static _FocusableViewRegionState? get currentlyFocusedRegion {
    for (final region in _regions) {
      if (region.hasRegionFocus) return region;
    }
    return null;
  }

  /// Finds the mounted and traversal-eligible [_FocusableViewRegionState]
  /// matching [targetRegion] on the active route/layer, or `null` if none is
  /// currently visible or enabled.
  static _FocusableViewRegionState? findEligibleRegion(
    ActiveFocusRegion targetRegion,
  ) {
    for (final region in _regions.reversed) {
      if (region.widget.regionInfo == targetRegion &&
          region.isEligibleForTraversal) {
        return region;
      }
    }
    return null;
  }
}
