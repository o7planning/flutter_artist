part of '../flutter_artist.dart';

class CurrentItemSelectionResult<ITEM> {
  final CurrentItemSelectionType currentItemSelectionType;
  final List<ITEM?> _candidateItems = [];
  ITEM? _oldCurrentItem;
  ITEM? _currentItem;
  Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  CurrentItemSelectionResult({
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

  void _addCandidateItem(ITEM? candidateItem) {
    _candidateItems.add(candidateItem);
  }

  ITEM? get firstCandidateItem {
    return _candidateItems.firstOrNull;
  }

  ITEM? get lastCandidateItem {
    return _candidateItems.lastOrNull;
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

  bool get success {
    switch (currentItemSelectionType) {
      case CurrentItemSelectionType.selectItemAsCurrentAndLoadForm:
        return _successfullySelectedToEdit();
      case CurrentItemSelectionType.selectItemAsCurrent:
        return _successfullySelectedToShow();
      case CurrentItemSelectionType.selectItemAsCurrentIfNeed:
        return _successfullySelectedDefault();
      case CurrentItemSelectionType.refresh:
        return _successfullySelectedToRefresh();
    }
  }
}

class ItemDeletionResult<ITEM> {
  List<ITEM> _candidateItems = [];
  List<ITEM> _deletedItems = [];
  List<ITEM> _failedItems = [];

  bool get success {
    // TODO: Xem lai.
    return _deletedItems.isNotEmpty;
  }

  void addCandidateItem(ITEM item) {
    _candidateItems.add(item);
  }

  void addDeletedItem(ITEM item) {
    _deletedItems.add(item);
  }

  void addDFailedItem(ITEM item) {
    _failedItems.add(item);
  }
}

class BlockQueryResult {
  bool _filterError = false;
  bool _apiError = false;

  bool get success {
    return !_filterError && !_apiError;
  }
}

class ScalarQueryResult {
  bool _filterError = false;
  bool _apiError = false;

  bool get success {
    return !_filterError && !_apiError;
  }
}
