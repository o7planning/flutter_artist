part of '../../core.dart';

class BlockFormViewBuilder extends BaseFormViewBuilder<BlockFormModel> {
  const BlockFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required super.formModel,
    required super.build,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });

  @override
  State<StatefulWidget> createState() {
    return _BlockFormViewBuilderState();
  }
}

class _BlockFormViewBuilderState
    extends _BaseFormViewBuilderState<BlockFormViewBuilder, BlockFormModel> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.form;

  @override
  Shelf? _getRelatedModule() {
    return widget.formModel.shelf;
  }

  @override
  BlockViewContext? get blockViewContext => BlockViewContext.form;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => null;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Future<bool> handleSaveOnPop() async {
    final BlockFormSaveResult result = await widget.formModel.saveForm();
    return result.successForAll;
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.formModel.shelf);
  }
}
