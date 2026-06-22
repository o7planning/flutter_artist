part of '../core.dart';

class BlockSetCurrentItemResult<ITEM>
    extends TaskResult<BlockSetCurrentItemPrecheck> {
  final BlockSetCurrentItemDirective setCurrentItemDirective;
  final List<ITEM> _candidateItems = [];
  ITEM? _oldCurrentItem;
  ITEM? _currentItem;
  final Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  BlockSetCurrentItemResult({
    required super.precheck,
    required this.setCurrentItemDirective,
    required Object Function(ITEM item) getItemId,
    //
    required ITEM? candidateItem,
    required ITEM? oldCurrentItem,
    required ITEM? currentItem,
  })  : _oldCurrentItem = oldCurrentItem,
        _currentItem = currentItem,
        _getItemId = getItemId {
    if (candidateItem != null) {
      _candidateItems.add(candidateItem);
    }
  }

  @override
  bool get successForAll {
    // TODO.
    return successForFirst;
  }

  @override
  bool get successForFirst {
    if (precheck != null) {
      return false;
    } else if (errorInfo != null) {
      return false;
    }
    switch (setCurrentItemDirective) {
      case BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm:
        return _successfullySelectedToEdit();
      case BlockSetCurrentItemDirective.setAnItemAsCurrent:
        return _successfullySelectedToShow();
      case BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed:
        return _successfullySelectedDefault();
      case BlockSetCurrentItemDirective.refresh:
        return _successfullySelectedToRefresh();
    }
  }

  void _addCandidateItem(ITEM candidateItem) {
    _candidateItems.add(candidateItem);
  }

  ITEM? get firstCandidateItem {
    return _candidateItems.firstOrNull;
  }

  ITEM? get lastCandidateItem {
    return _candidateItems.lastOrNull;
  }

  bool _successfullyDoNothing() {
    return true;
  }

  bool _successfullySelectedToEdit() {
    if (_candidateItems.isEmpty || _currentItem == null) {
      return false;
    }
    if (_getItemId(_candidateItems[0]) != _getItemId(_currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedToShow() {
    if (_candidateItems.isEmpty || _currentItem == null) {
      return false;
    }
    if (_getItemId(_candidateItems[0]!) != _getItemId(_currentItem!)) {
      return false;
    }
    return true;
  }

  // TODO: Rename??
  bool _successfullySelectedToRefresh() {
    if (_candidateItems.isEmpty || _currentItem == null) {
      return false;
    }
    if (_getItemId(_candidateItems[0]!) != _getItemId(_currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedDefault() {
    return _apiError || _convertError;
  }
}
