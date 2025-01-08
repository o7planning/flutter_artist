part of '../flutter_artist.dart';

class NBBFWraper {
  Scalar? scalar;
  Block? block;
  BlockForm? blockForm;

  NBBFWraper.scalar(Scalar this.scalar);

  NBBFWraper.block(Block this.block);

  NBBFWraper.blockForm(BlockForm this.blockForm);

  @override
  String toString() {
    if (scalar != null) {
      return getClassName(scalar);
    } else if (block != null) {
      return getClassName(block);
    } else if (blockForm != null) {
      return getClassName(blockForm);
    }
    return super.toString();
  }
}
