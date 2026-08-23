part of '../core.dart';

/// Mutable runtime operational configuration governing the active execution,
/// pagination boundaries, sorting, and lifecycle rules of a [Block].
///
/// While [BlockConfig] acts as the static, immutable seed blueprint supplied
/// during declaration, [BlockEffectiveConfig] represents the active state layer
/// that can adapt dynamically during runtime.
class BlockEffectiveConfig {
  /// Reference to the immutable baseline configuration used to seed this instance.
  final BlockConfig _baselineConfig;

  /// The active querying strategy applied for subsequent fetch cycles.
  late BlockNativeQueryMode _nativeQueryMode;

  /// The active pagination state.
  ///
  /// Nullable by design: resolves to `null` when operating in [BlockNativeQueryMode.fullQuery],
  /// or holds the active [Pageable] instance when in [BlockNativeQueryMode.pageableQuery].
  Pageable? _currentPageable;

  /// Private constructor initializing runtime settings from baseline [BlockConfig].
  BlockEffectiveConfig._fromConfig(this._baselineConfig) {
    _nativeQueryMode = _baselineConfig.nativeQueryMode;
    _currentPageable =
        _baselineConfig.nativeQueryMode == BlockNativeQueryMode.fullQuery
            ? null
            : _baselineConfig.pageable.copy();
  }

  /// Factory constructor to instantiate an effective config bound to a baseline [BlockConfig].
  factory BlockEffectiveConfig.fromConfig(BlockConfig config) {
    return BlockEffectiveConfig._fromConfig(config);
  }

  @Deprecated("No longer supported")
  ItemAbsentRepresentativePolicy get itemAbsentRepresentativePolicy =>
      _baselineConfig.itemAbsentRepresentativePolicy;

  @Deprecated("No longer supported")
  UnifiedItemRefreshPolicy get unifiedItemRefreshPolicy =>
      _baselineConfig.unifiedItemRefreshPolicy;

  BlockHiddenAction get onHideAction => _baselineConfig.onHideAction;

  // ===========================================================================
  // MUTABLE RUNTIME GETTERS & SETTERS
  // ===========================================================================

  /// The active querying mode currently governing block data fetch operations.
  BlockNativeQueryMode get nativeQueryMode => _nativeQueryMode;

  /// Mutates the active querying strategy for this block.
  ///
  /// Rejects mutation and returns `false` if [isNativeQueryModeLocked] is enabled
  /// in the baseline configuration.
  bool setNativeQueryMode(BlockNativeQueryMode newMode) {
    if (_baselineConfig.isNativeQueryModeLocked) {
      return false;
    }
    _nativeQueryMode = newMode;
    if (newMode == BlockNativeQueryMode.fullQuery) {
      _currentPageable = null;
    } else if (_currentPageable == null) {
      _currentPageable = _baselineConfig.pageable.copy();
    }
    return true;
  }

  /// The active pagination instance, or `null` if operating in full query mode.
  Pageable? get currentPageable => _currentPageable;

  /// Updates the active pagination state.
  ///
  /// Automatically aligns [nativeQueryMode] to [BlockNativeQueryMode.pageableQuery]
  /// if a non-null [Pageable] instance is assigned.
  void setCurrentPageable(Pageable? pageable) {
    _currentPageable = pageable;
    if (pageable != null) {
      _nativeQueryMode = BlockNativeQueryMode.pageableQuery;
    } else {
      _nativeQueryMode = BlockNativeQueryMode.fullQuery;
    }
  }

  // ===========================================================================
  // DELEGATED IMMUTABLE BASELINE PROPERTIES
  // ===========================================================================

  /// Dictates whether this block's query depends on ancestor payload changes.
  bool get bindToAncestorPayloadState =>
      _baselineConfig.bindToAncestorPayloadState;

  /// Enforces relational parent-link integrity across in-memory items.
  bool get enforceParentLinkConstraint =>
      _baselineConfig.enforceParentLinkConstraint;

  /// Protects dirty form inputs and unsaved edits from being discarded during re-queries.
  bool get preventUnsavedChangesLoss =>
      _baselineConfig.preventUnsavedChangesLoss;

  /// Indicates whether mutating [nativeQueryMode] at runtime is prohibited.
  bool get isNativeQueryModeLocked => _baselineConfig.isNativeQueryModeLocked;

  /// Defines whether this block broadcasts event updates to external domain listeners.
  bool get eventBroadcastEnabled => _baselineConfig.eventBroadcastEnabled;

  bool get eventReactionEnabled => _baselineConfig.eventReactionEnabled;

  /// Additional domain event data types broadcasted beyond the primary item schemas.
  List<Type> get extraBroadcastEvents => _baselineConfig.extraBroadcastEvents;

  /// Client-side in-memory sorting strategy applied over the loaded item list.
  SortStrategy get clientSideSortStrategy =>
      _baselineConfig.clientSideSortStrategy;

  /// Viewport reconciliation policy governing item collection sync on data mutations.
  BlockViewportSyncConfig get viewportSyncConfig =>
      _baselineConfig.viewportSyncConfig;

  /// Registered event reactions dictating how this block responds to external notifications.
  List<BlockEventReaction> get reactions => _baselineConfig.reactions;

  // ===========================================================================
  // LIFECYCLE CONTROLS
  // ===========================================================================

  /// Restores all mutable runtime properties back to their initial baseline configuration values.
  void resetToBaseline() {
    _nativeQueryMode = _baselineConfig.nativeQueryMode;
    _currentPageable =
        _baselineConfig.nativeQueryMode == BlockNativeQueryMode.fullQuery
            ? null
            : _baselineConfig.pageable.copy();
  }
}
