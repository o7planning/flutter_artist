part of '../core.dart';

/// Sealed hierarchy representing the lifecycle state of the active [currentItem].
@immutable
sealed class BlockItemDataState {
  const BlockItemDataState();

  bool get isNone => this is BlockItemDataStateNone;

  bool get isFresh => this is BlockItemDataStateFresh;

  bool get isStale => this is BlockItemDataStateStale;

  String toBriefInfo();
}

/// No item is currently selected.
final class BlockItemDataStateNone extends BlockItemDataState {
  const BlockItemDataStateNone();

  @override
  String toBriefInfo() => 'none()';

  @override
  String toString() => 'BlockItemDataState.none()';
}

/// Item detail is fully loaded and fresh in RAM.
final class BlockItemDataStateFresh extends BlockItemDataState {
  const BlockItemDataStateFresh();

  @override
  String toBriefInfo() => 'fresh()';

  @override
  String toString() => 'BlockItemDataState.fresh()';
}

/// Item detail in RAM is outdated due to incoming target:currentItem events.
final class BlockItemDataStateStale extends BlockItemDataState {
  final ErrorInfo? errorInfo;

  const BlockItemDataStateStale({this.errorInfo});

  @override
  String toBriefInfo() => 'stale(${errorInfo == null ? '' : 'err'})';

  @override
  String toString() => 'BlockItemDataState.stale(errorInfo: $errorInfo)';
}
