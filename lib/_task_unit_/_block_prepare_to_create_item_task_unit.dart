part of '../flutter_artist.dart';

class _BlockPrepareToCreateItemTaskUnit extends _TaskUnit {
  _XBlock xBlock;
  ExtraFormInput? extraFormInput;
  Function()? navigate;
  final bool initDirty;

  _BlockPrepareToCreateItemTaskUnit({
    required this.xBlock,
    required this.initDirty,
    required this.extraFormInput,
    required this.navigate,
  });

  @override
  int get xShelfId => xBlock.xShelfId;

  @override
  Shelf get shelf => xBlock.block.shelf;

  @override
  String getObjectName() {
    return xBlock.block.name;
  }
}
