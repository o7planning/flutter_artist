part of '../../core.dart';

class _XShelfBlockFormModelPatchFormFields extends XShelf {
  _XShelfBlockFormModelPatchFormFields({
    required BlockFormModel formModel,
  }) : super(
          xShelfType: XShelfType.formModelPatchFormFields,
          shelf: formModel.block.shelf,
        ) {
    //
  }
}
