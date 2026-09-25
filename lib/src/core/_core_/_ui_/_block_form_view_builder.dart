part of '../core.dart';

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
  Shelf? _getRelatedShelf() {
    return widget.formModel.shelf;
  }

  @override
  Activity? _getRelatedActivity() {
    return null;
  }

  @override
  bool get provideBlockContext => true;

  @override
  bool get provideStageContext => false;

  @override
  bool get provideTaskContext => false;

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
