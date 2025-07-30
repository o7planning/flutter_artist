part of '../_debug.dart';

class _GraphItem {
  BlockOrScalar? blockOrScalar;
  Shelf? shelf;

  final List<_GraphItem> children = [];

  _GraphItem.shelf(this.shelf);

  _GraphItem.blockOrScalar(this.blockOrScalar);

  String get name {
    if (shelf != null) {
      return "-";
    } else {
      return blockOrScalar!.name;
    }
  }
}

class _GraphGItem {
  bool isRoot;
  bool isNotifier;
  bool isListener;
  String shelfName;
  Shelf? shelf;

  final List<_GraphGItem> children = [];

  _GraphGItem({
    required this.isRoot,
    required this.isListener,
    required this.isNotifier,
    required this.shelfName,
    this.shelf,
  });
}
