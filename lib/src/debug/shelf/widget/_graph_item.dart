import '../../../core/_core_/core.dart';
import '../../storage/_block_or_scalar.dart';

class GraphItem {
  BlockOrScalar? blockOrScalar;
  Shelf? shelf;

  final List<GraphItem> children = [];

  GraphItem.shelf(this.shelf);

  GraphItem.blockOrScalar(this.blockOrScalar);

  String get name {
    if (shelf != null) {
      return "-";
    } else {
      return blockOrScalar!.name;
    }
  }
}

class GraphGItem {
  bool isRoot;
  bool isNotifier;
  bool isListener;
  String shelfName;
  Shelf? shelf;

  final List<GraphGItem> children = [];

  GraphGItem({
    required this.isRoot,
    required this.isListener,
    required this.isNotifier,
    required this.shelfName,
    this.shelf,
  });
}
