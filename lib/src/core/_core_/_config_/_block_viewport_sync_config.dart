part of '../core.dart';

/// The centralized boundary configuration defining how runtime block viewports
/// adapt and merge mutation footprints under strict structural rules.
class BlockViewportSyncConfig {
  /// The absolute minimum strategy allowed. Any action requesting a strategy
  /// below this threshold will be automatically upgraded to this floor level.
  final BlockViewportSyncStrategy minViewportSyncStrategy;

  /// The active priority mode that dictates conflict resolution rules.
  final BlockViewportSyncHierarchyMode viewportSyncHierarchyMode;

  const BlockViewportSyncConfig({
    this.minViewportSyncStrategy = BlockViewportSyncStrategy.effectedItemIdsQuery,
    this.viewportSyncHierarchyMode =
        BlockViewportSyncHierarchyMode.effectedAndViewportItemIdsQueryIsHighest,
  });
}
