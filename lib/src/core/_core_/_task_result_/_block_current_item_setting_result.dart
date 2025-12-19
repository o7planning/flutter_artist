part of '../core.dart';

class BlockCurrentItemSettingResult<ITEM>
    extends TaskResult<BlockCurrentItemSettingPrecheck> {
  final CurrentItemSettingType currentItemSettingType;
  final List<ITEM> _candidateItems = [];
  ITEM? _oldCurrentItem;
  ITEM? _currentItem;
  final Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  BlockCurrentItemSettingResult({
    required super.precheck,
    required this.currentItemSettingType,
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
    switch (currentItemSettingType) {
      case CurrentItemSettingType.setAnItemAsCurrentThenLoadForm:
        return _successfullySelectedToEdit();
      case CurrentItemSettingType.setAnItemAsCurrent:
        return _successfullySelectedToShow();
      case CurrentItemSettingType.setAnItemAsCurrentIfNeed:
        return _successfullySelectedDefault();
      case CurrentItemSettingType.refresh:
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
