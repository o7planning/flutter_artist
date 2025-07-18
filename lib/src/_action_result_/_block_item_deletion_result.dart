part of '../../flutter_artist.dart';

class ItemDeletionResult<ITEM> extends ActionResult {
  final BlockCanDeleteItemCode? precheck;
  List<ITEM> _candidateItems = [];
  List<ITEM> _deletedItems = [];
  List<ITEM> _failedItems = [];

  ItemDeletionResult({this.precheck});

  @override
  bool get success {
    if (precheck != null) {
      return false;
    }
    // TODO: Xem lai.
    return _deletedItems.isNotEmpty;
  }

  void addCandidateItem(ITEM item) {
    _candidateItems.add(item);
  }

  void addDeletedItem(ITEM item) {
    _deletedItems.add(item);
  }

  void addFailedItem(ITEM item) {
    _failedItems.add(item);
  }
}
