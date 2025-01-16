part of '../flutter_artist.dart';

class _ScalarOrBlockOrFormWrapper {
  Scalar? scalar;
  Block? block;
  BlockForm? blockForm;

  _ScalarOrBlockOrFormWrapper.scalar(Scalar this.scalar);

  _ScalarOrBlockOrFormWrapper.block(Block this.block);

  _ScalarOrBlockOrFormWrapper.blockForm(BlockForm this.blockForm);

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
