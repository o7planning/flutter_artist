part of '../flutter_artist.dart';

class _ScalarOrBlockOrFormWrapper {
  Scalar? scalar;
  Block? block;
  FormModel? formModel;

  _ScalarOrBlockOrFormWrapper.scalar(Scalar this.scalar);

  _ScalarOrBlockOrFormWrapper.block(Block this.block);

  _ScalarOrBlockOrFormWrapper.formModel(FormModel this.formModel);

  @override
  String toString() {
    if (scalar != null) {
      return getClassName(scalar);
    } else if (block != null) {
      return getClassName(block);
    } else if (formModel != null) {
      return getClassName(formModel);
    }
    return super.toString();
  }
}
