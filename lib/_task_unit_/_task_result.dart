part of '../flutter_artist.dart';

class CurrentItemSelectionResult<ITEM> {
  final CurrentItemSelectionType currentItemSelectionType;
  final List<ITEM?> candidateItems = [];
  ITEM? oldCurrentItem;
  ITEM? currentItem;
  Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  CurrentItemSelectionResult({
    required this.currentItemSelectionType,
    required Object Function(ITEM item) getItemId,
    //
    required ITEM? candidateItem,
    required this.oldCurrentItem,
    required this.currentItem,
  }) : _getItemId = getItemId {
    if (candidateItem != null) {
      candidateItems.add(candidateItem);
    }
  }

  void _addCandidateItem(ITEM? candidateItem) {
    candidateItems.add(candidateItem);
  }

  ITEM? get firstCandidateItem {
    return candidateItems.firstOrNull;
  }

  ITEM? get lastCandidateItem {
    return candidateItems.lastOrNull;
  }

  bool _successfullySelectedToEdit() {
    if (candidateItems.isEmpty || currentItem == null) {
      return false;
    }
    if (_getItemId(candidateItems[0]!) != _getItemId(currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedToShow() {
    if (candidateItems.isEmpty || currentItem == null) {
      return false;
    }
    if (_getItemId(candidateItems[0]!) != _getItemId(currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedToRefresh() {
    if (candidateItems.isEmpty || currentItem == null) {
      return false;
    }
    if (_getItemId(candidateItems[0]!) != _getItemId(currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedDefault() {
    return _apiError || _convertError;
  }

  bool get success {
    switch (currentItemSelectionType) {
      case CurrentItemSelectionType.selectAsCurrentToEdit:
        return _successfullySelectedToEdit();
      case CurrentItemSelectionType.selectAsCurrentToShow:
        return _successfullySelectedToShow();
      case CurrentItemSelectionType.selectAsCurrentForDefault:
        return _successfullySelectedDefault();
      case CurrentItemSelectionType.refresh:
        return _successfullySelectedToRefresh();
    }
  }
}

class ItemDeletionResult<ITEM> {
  List<ITEM> candidateItems = [];
  List<ITEM> deletedItems = [];
  List<ITEM> failedItems = [];

  bool get success {
    // TODO: Xem lai.
    return deletedItems.isNotEmpty;
  }

  void addCandidateItem(ITEM item) {
    candidateItems.add(item);
  }

  void addDeletedItem(ITEM item) {
    deletedItems.add(item);
  }

  void addDFailedItem(ITEM item) {
    failedItems.add(item);
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
