part of '../../core.dart';

class _XShelfFormModelEnterFields extends XShelf {
  _XShelfFormModelEnterFields({required FormModel formModel})
      : super(
          xShelfType: XShelfType.formModelEnterFields,
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
