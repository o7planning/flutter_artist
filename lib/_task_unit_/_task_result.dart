part of '../flutter_artist.dart';

class CurrentItemSelectionResult<ID, ITEM> {
  final CurrentItemSelectionType currentItemSelectionType;
  final List<ITEM?> candidateItems = [];
  ITEM? oldCurrentItem;
  ITEM? currentItem;
  ID Function(ITEM item) getItemId;
  bool _apiError = false;
  bool _convertError = false;

  CurrentItemSelectionResult({
    required this.currentItemSelectionType,
    required this.getItemId,
    //
    required ITEM? candidateItem,
    required this.oldCurrentItem,
    required this.currentItem,
  }) {
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
    if (getItemId(candidateItems[0]!) != getItemId(currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedToShow() {
    if (candidateItems.isEmpty || currentItem == null) {
      return false;
    }
    if (getItemId(candidateItems[0]!) != getItemId(currentItem!)) {
      return false;
    }
    return true;
  }

  bool _successfullySelectedToRefresh() {
    if (candidateItems.isEmpty || currentItem == null) {
      return false;
    }
    if (getItemId(candidateItems[0]!) != getItemId(currentItem!)) {
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
  bool _convertError = false;

  bool get success {
    return !_filterError && !_apiError && !_convertError;
  }
}

class ScalarQueryResult {
  // TODO
  bool success = true;
}
