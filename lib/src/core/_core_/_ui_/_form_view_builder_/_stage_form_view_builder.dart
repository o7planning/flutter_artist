part of '../../core.dart';

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
  Activity? _getRelatedShelf() {
    return widget.formModel.stage.activity;
  }


  @override
  BlockContextType? get blockContextType => null;

  @override
  ScalarContextType? get scalarContextType => null;

  @override
  StageContextType? get stageContextType => StageContextType.form;

  @override
  TaskContextType? get taskContextType => null;

  @override
  Future<bool> handleSaveOnPop() async {
    // final bool success = await widget.formModel.submit();
    // return success;

    throw UnimplementedError("TODO: handleSaveOnPop");
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.formModel.stage.activity);
  }
}
