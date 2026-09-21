part of '../core.dart';

/// Configuration options defining runtime lifecycle policies and directional
/// external event communication boundaries for a [Shelf].
class ShelfConfig {
  /// Defines how this Shelf is retained in memory or released when unmounted.
  final ShelfReleasePolicy releasePolicy;

  /// Domain namespace tags attached when broadcasting events EXTERNALLY to other shelves.
  ///
  /// - Defaults to `{'*'}` (wildcard), allowing external shelves to observe emitted events.
  /// - An empty set `const {}` silences this shelf to external observers (pure consumer).
  final Set<String> broadcastTags;

  /// Domain namespace tags that this shelf ACCEPTS from external shelves.
  ///
  /// - Defaults to `{'*'}` (wildcard), accepting external events from any valid broadcasting shelf.
  /// - An empty set `const {}` shields this shelf from any external event notifications (pure producer).
  /// - A specific set (e.g. `{'order', 'billing'}`) restricts incoming external events exclusively
  ///   to shelves whose [broadcastTags] intersect with this set.
  final Set<String> reactionTags;

  /// Wildcard identifier representing unrestricted global domain scope.
  static const String wildcardTag = '*';

  const ShelfConfig({
    this.releasePolicy = ShelfReleasePolicy.retain,
    this.broadcastTags = const {wildcardTag},
    this.reactionTags = const {wildcardTag},
  });

  /// Creates an immutable copy of this configuration with optional overrides.
  ShelfConfig copy({
    ShelfReleasePolicy? releasePolicy,
    Set<String>? broadcastTags,
    Set<String>? reactionTags,
  }) {
    return ShelfConfig(
      releasePolicy: releasePolicy ?? this.releasePolicy,
      broadcastTags: broadcastTags ?? Set.unmodifiable(this.broadcastTags),
      reactionTags: reactionTags ?? Set.unmodifiable(this.reactionTags),
    );
  }
}

/// Active runtime configuration wrapper for [ShelfConfig] providing fast evaluation
/// of cross-shelf event boundaries.
class ShelfEffectiveConfig {
  final ShelfConfig _baselineConfig;
  final Set<String> _broadcastTags;
  final Set<String> _reactionTags;

  ShelfEffectiveConfig._fromConfig(this._baselineConfig)
      : _broadcastTags = Set.unmodifiable(_baselineConfig.broadcastTags),
        _reactionTags = Set.unmodifiable(_baselineConfig.reactionTags);

  factory ShelfEffectiveConfig.fromConfig(ShelfConfig config) =>
      ShelfEffectiveConfig._fromConfig(config);

  /// Active release policy governing shelf disposal.
  ShelfReleasePolicy get releasePolicy => _baselineConfig.releasePolicy;

  /// Outbound tags published to external shelves.
  Set<String> get broadcastTags => _broadcastTags;

  /// Inbound tags permitted from external shelves.
  Set<String> get reactionTags => _reactionTags;

  /// Indicates whether this shelf accepts external events from any broadcasting source.
  bool get acceptsGlobalEvents =>
      _reactionTags.contains(ShelfConfig.wildcardTag);

  /// Evaluates whether this target shelf allows receiving events emitted by [sourceConfig].
  ///
  /// Strict boundary evaluation:
  /// 1. If source emits no broadcast tags -> REJECT.
  /// 2. If target listens to no reaction tags -> REJECT.
  /// 3. If target listens to wildcard `*` -> ACCEPT (provided source emits at least one tag).
  /// 4. If source emits wildcard `*` -> ACCEPT only if target accepts wildcard `*`.
  /// 5. Otherwise, requires set intersection between [sourceConfig.broadcastTags] and [reactionTags].
  bool canAcceptEventFrom(ShelfEffectiveConfig sourceConfig) {
    if (sourceConfig.broadcastTags.isEmpty) {
      return false;
    }
    if (_reactionTags.isEmpty) {
      return false;
    }
    if (acceptsGlobalEvents) {
      return true;
    }
    return sourceConfig.broadcastTags.any(_reactionTags.contains);
  }
}
