part of '../core.dart';

class StageFormViewBuilder extends BaseFormViewBuilder<StageFormModel> {
  const StageFormViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required super.formModel,
    required super.build,
    super.quickSuggestionMode = QuickSuggestionMode.showIfError,
  });

  @override
  State<StatefulWidget> createState() {
    return _StageFormViewBuilderState();
  }
}

class _StageFormViewBuilderState
    extends _BaseFormViewBuilderState<StageFormViewBuilder, StageFormModel> {
  @override
  ContextProviderViewType get type => ContextProviderViewType.stageView;

  @override
  Shelf? _getRelatedShelf() {
    return null;
  }

  @override
  Activity? _getRelatedActivity() {
    return widget.formModel.stage.activity;
  }

  @override
  bool get provideBlockContext => false;

  @override
  bool get provideStageContext => true;

  @override
  bool get provideTaskContext => false;

  @override
  Future<bool> handleSaveOnPop() async {
    final bool success = await widget.formModel.submit();
    return success;
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.formModel.stage.activity);
  }
}
