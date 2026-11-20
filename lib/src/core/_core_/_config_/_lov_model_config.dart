part of '../core.dart';

/// Configuration options for a [LovModel].
class LovModelConfig {
  final LovSelectionMode selectionMode;
  final BlockNativeQueryMode nativeQueryMode;
  final Pageable? pageable;
  final SortStrategy clientSideSortStrategy;
  final bool eventReactionEnabled;
  final List<Type> reactionDataTypes;

  /// Whether existing selections are preserved when navigating across pages
  /// in [BlockNativeQueryMode.pageableQuery] mode.
  final bool preserveSelectionAcrossPages;

  const LovModelConfig({
    this.selectionMode = LovSelectionMode.single,
    this.nativeQueryMode = BlockNativeQueryMode.pageableQuery,
    this.pageable,
    this.clientSideSortStrategy = SortStrategy.none,
    this.eventReactionEnabled = true,
    this.reactionDataTypes = const [],
    this.preserveSelectionAcrossPages = true,
  });

  LovModelConfig copy() {
    return LovModelConfig(
      selectionMode: selectionMode,
      nativeQueryMode: nativeQueryMode,
      pageable: pageable?.copy(),
      clientSideSortStrategy: clientSideSortStrategy,
      eventReactionEnabled: eventReactionEnabled,
      reactionDataTypes: [...reactionDataTypes],
      preserveSelectionAcrossPages: preserveSelectionAcrossPages,
    );
  }
}
