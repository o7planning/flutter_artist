part of '../../core.dart';

class _XShelfFormModelSave extends XShelf {
  _XShelfFormModelSave({required FormModel formModel})
      : super(
          xShelfType: XShelfType.formModelSave,
          shelf: formModel.block.shelf,
          resetReactionTypeToExternal: true,
        ) {
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }
}
