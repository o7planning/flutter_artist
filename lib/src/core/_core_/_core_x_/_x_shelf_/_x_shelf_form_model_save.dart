part of '../../core.dart';

class _XShelfFormModelSave extends XShelf {
  _XShelfFormModelSave({
    required BlockFormModel formModel,
  }) : super(
          xShelfType: XShelfType.formModelSave,
          shelf: formModel.block.shelf,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
  }
}
