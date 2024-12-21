part of '../flutter_artist.dart';

class BlockAndFormWraper {
  Block? block;
  BlockForm? blockForm;

  BlockAndFormWraper.block(Block this.block);

  BlockAndFormWraper.blockForm(BlockForm this.blockForm);

  @override
  String toString() {
    return block != null ? getClassName(block) : getClassName(blockForm!);
  }
}
