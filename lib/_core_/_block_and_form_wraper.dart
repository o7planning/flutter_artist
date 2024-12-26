part of '../flutter_artist.dart';

class NBBFWraper {
  NonBlock? nonBlock;
  Block? block;
  BlockForm? blockForm;

  NBBFWraper.nonBlock(NonBlock this.nonBlock);

  NBBFWraper.block(Block this.block);

  NBBFWraper.blockForm(BlockForm this.blockForm);

  @override
  String toString() {
    if (nonBlock != null) {
      return getClassName(nonBlock);
    } else if (block != null) {
      return getClassName(block);
    } else if (blockForm != null) {
      return getClassName(blockForm);
    }
    return super.toString();
  }
}
