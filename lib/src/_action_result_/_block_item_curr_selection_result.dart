part of '../../flutter_artist.dart';

// Old Name: CurrentItemSelectionResult
class BlockItemCurrSelectionResult<ITEM> extends ActionResult {
  final BlockItemCurrSelectionPrecheck? precheck;
  AppError? _appError;

  AppError? get error => _appError;

  final CurrentItemSelectionType currentItemSelectionType;
  final List<ITEM?> _candidateItems = [];
  ITEM? _oldCurrentItem;
  ITEM? _currentItem;
  Object Function(ITEM item) _getItemId;
  bool _apiError = false;
  bool _convertError = false;

  BlockItemCurrSelectionResult({
    required this.precheck,
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
  bool get success {
    switch (currentItemSelectionType) {
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

  void _setAppError({required AppError appError}) {
    _appError = appError;
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
}
