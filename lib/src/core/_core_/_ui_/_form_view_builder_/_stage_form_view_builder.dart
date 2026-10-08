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
  Activity? _getRelatedModule() {
    return widget.formModel.stage.activity;
  }

  @override
  BlockViewContext? get blockViewContext => null;

  @override
  ScalarViewContext? get scalarContextType => null;

  @override
  ProzessViewContext? get prozessViewContext => null;

  @override
  StageViewContext? get stageViewContext => StageViewContext.form;

  @override
  TaskViewContext? get taskViewContext => null;

  @override
  Widget buildContent(BuildContext context) {
    // Guard clause: Ensure StageFormView is correctly placed inside a ProzessStageFormViewSwitcher.
    final isValid = _StageFormViewSwitcherScope.maybeOf(context) != null;
    if (!isValid) {
      return const ErrorMessageView(
        message:
            'StageFormView and StageFormViewBuilder must be child widgets of ProzessStageFormViewSwitcher!',
      );
    }
    return super.buildContent(context);
  }

  @override
  Future<bool> handleSaveOnPop() async {
    throw UnimplementedError("TODO: handleSaveOnPop");
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.desk._checkToRemoveActivity(widget.formModel.stage.activity);
  }
}
