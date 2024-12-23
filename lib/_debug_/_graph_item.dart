part of '../flutter_artist.dart';

class _GraphItem {
  Block? block;
  Shelf? shelf;

  final List<_GraphItem> children = [];

  _GraphItem.shelf(this.shelf);

  _GraphItem.block(this.block);

  String get name {
    if (shelf != null) {
      return "-";
    } else {
      return block!.name;
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
