part of '../flutter_artist.dart';

class _GraphItem {
  Block? block;
  Frame? frame;

  final List<_GraphItem> children = [];

  _GraphItem.frame(this.frame);

  _GraphItem.block(this.block);

  String get name {
    if (frame != null) {
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
  String frameName;
  Frame? frame;

  final List<_GraphGItem> children = [];

  _GraphGItem({
    required this.isRoot,
    required this.isListener,
    required this.isNotifier,
    required this.frameName,
    this.frame,
  });
}
