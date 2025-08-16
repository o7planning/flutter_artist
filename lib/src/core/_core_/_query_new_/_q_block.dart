part of '../core.dart';

class _QBlock {
  _QShelf get xShelf => xFilterModel.xShelf;
  final Block block;

  late final _QBlock? parentXBlock;
  final _QFilterModel xFilterModel;
  final _QFormModel? xFormModel;

  String get name => block.name;

  _QBlock({
    required this.block,
    required this.xFilterModel,
    required this.xFormModel,
  });
}
