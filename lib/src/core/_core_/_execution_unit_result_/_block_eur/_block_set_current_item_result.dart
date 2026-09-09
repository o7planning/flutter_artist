part of '../../core.dart';

/// Execution unit result representing the outcome of selecting, refreshing,
/// or transitioning the active current item within a [Block].
class BlockSetCurrentItemResult<
        ID extends Comparable, //
        ITEM extends Identifiable<ID>,
        ITEM_DETAIL extends Identifiable<ID>>
    extends BlockExecutionUnitResult<ID, ITEM, ITEM_DETAIL,
        BlockSetCurrentItemPrecheck> {
  /// The operational directive governing how selection fallback was resolved.
  final BlockSetCurrentItemDirective setCurrentItemDirective;

  /// The original candidate item targeted by the caller at the beginning of the execution.
  final ITEM? initialCandidateItem;

  /// The item that was actively assigned before this execution began.
  final ITEM? oldCurrentItem;

  /// The item actively assigned as current upon completion.
  ITEM? _currentItem;

  /// Retrieves the item currently assigned as active after execution completes.
  ITEM? get currentItem => _currentItem;

  /// Setter used by internal unit execution to update the final assigned item.
  void setCurrentItem(ITEM? item) {
    _currentItem = item;
  }

  BlockSetCurrentItemResult({
    required super.precheck,
    required this.setCurrentItemDirective,
    required ITEM? candidateItem,
    required this.oldCurrentItem,
    required ITEM? currentItem,
  })  : initialCandidateItem = candidateItem,
        _currentItem = currentItem;

  /// Indicates whether the selection achieved its primary objective without unhandled errors.
  @override
  bool get successForFirst {
    if (precheck != null || errorInfo != null) {
      return false;
    }

    switch (setCurrentItemDirective) {
      case BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm:
      case BlockSetCurrentItemDirective.setAnItemAsCurrent:
      case BlockSetCurrentItemDirective.refresh:
        // Must successfully match the targeted initial candidate item
        if (initialCandidateItem == null || _currentItem == null) {
          return false;
        }
        return initialCandidateItem!.id == _currentItem!.id;

      case BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed:
        // Default lenient mode: successful if no error occurred, even if current is null
        return true;
    }
  }

  @override
  bool get successForAll => successForFirst;

  /// Determines whether the active current item actually changed from its prior state.
  bool get hasCurrentItemChanged => oldCurrentItem?.id != _currentItem?.id;

  /// Determines whether the initial targeted candidate was successfully assigned as current.
  bool get isTargetCandidateSelected =>
      initialCandidateItem != null &&
      _currentItem != null &&
      initialCandidateItem!.id == _currentItem!.id;
}
