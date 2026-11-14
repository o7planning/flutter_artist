part of '../core.dart';

/// Immutable descriptor representing a view region that currently holds keyboard focus.
class ActiveFocusRegion {
  /// Name of the owning [FeatureModule] ([Shelf] or [Activity]), if applicable.
  final String? moduleName;

  /// Logical name of the owning unit (e.g., [Block.name], [FilterModel.name], [Task.name]).
  final String unitName;

  /// Semantic type of the focused view region.
  final FocusRegionType regionType;

  const ActiveFocusRegion({
    required this.moduleName,
    required this.unitName,
    required this.regionType,
  });

  /// Formatted breadcrumb path for status bar display (e.g., `"product-block / itemsView"`).
  String get displayPath => '$unitName / ${regionType.label}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveFocusRegion &&
          runtimeType == other.runtimeType &&
          moduleName == other.moduleName &&
          unitName == other.unitName &&
          regionType == other.regionType;

  @override
  int get hashCode => Object.hash(moduleName, unitName, regionType);

  @override
  String toString() =>
      'ActiveFocusRegion(module: $moduleName, path: $displayPath)';
}
