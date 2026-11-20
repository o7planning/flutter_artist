part of '../core.dart';

/// Sealed hierarchy representing the lifecycle state of the active [currentItem].
@immutable
sealed class BlockItemDataState {
  const BlockItemDataState();

  bool get isNone => this is BlockItemDataStateNone;

  bool get isLoaded => this is BlockItemDataStateLoaded;

  bool get isLoadedFresh => this is BlockItemDataStateLoadedFresh;

  bool get isLoadedStale => this is BlockItemDataStateLoadedStale;

  String toBriefInfo();
}

sealed class BlockItemDataStateLoaded extends BlockItemDataState {
  const BlockItemDataStateLoaded();
}

/// No item is currently selected.
final class BlockItemDataStateNone extends BlockItemDataStateLoaded {
  const BlockItemDataStateNone();

  @override
  String toBriefInfo() => "none()";

  @override
  String toString() => 'BlockItemDataState.none()';
}

/// Item detail is fully loaded and fresh in RAM.
final class BlockItemDataStateLoadedFresh extends BlockItemDataStateLoaded {
  const BlockItemDataStateLoadedFresh();

  @override
  String toBriefInfo() => "loadedFresh()";

  @override
  String toString() => 'BlockItemDataState.fresh()';
}

/// Item detail in RAM is outdated due to incoming target:currentItem events.
final class BlockItemDataStateLoadedStale extends BlockItemDataState {
  final ErrorInfo? errorInfo;

  const BlockItemDataStateLoadedStale({this.errorInfo});

  @override
  String toBriefInfo() => "loadedStale(${errorInfo == null ? '' : 'err'})";

  @override
  String toString() => 'BlockItemDataState.stale(errorInfo: $errorInfo)';
}
