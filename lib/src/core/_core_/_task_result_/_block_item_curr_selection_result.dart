part of '../core.dart';

class BlockItemCurrSelectionResult<ITEM>
    extends TaskResult<BlockItemCurrSelectionPrecheck> {
  final CurrentItemSelectionType currentItemSelectionType;
  final List<ITEM?> _candidateItems = [];
  ITEM? _oldCurrentItem;
  ITEM? _currentItem;
  final Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  BlockItemCurrSelectionResult({
    required super.precheck,
    required this.currentItemSelectionType,
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
    } else if (error != null) {
      return false;
    }
    switch (currentItemSelectionType) {
      case CurrentItemSelectionType.doNothing:
        return _successfullyDoNothing();
      case CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm:
        return _successfullySelectedToEdit();
      case CurrentItemSelectionType.selectAnItemAsCurrent:
        return _successfullySelectedToShow();
      case CurrentItemSelectionType.selectAnItemAsCurrentIfNeed:
        return _successfullySelectedDefault();
      case CurrentItemSelectionType.refresh:
        return _successfullySelectedToRefresh();
    }
  }

  void _addCandidateItem(ITEM? candidateItem) {
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
    if (_getItemId(_candidateItems[0] as ITEM) != _getItemId(_currentItem!)) {
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
