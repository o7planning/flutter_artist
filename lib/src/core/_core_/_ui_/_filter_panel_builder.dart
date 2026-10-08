part of '../core.dart';

class _FilterPanelBuilder extends _ContextProviderView {
  final FilterModel filterModel;
  final Widget Function() build;

  final BlockContextType? blockContextType;
  final ScalarContextType? scalarContextType;

  const _FilterPanelBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.filterModel,
    required this.build,
    this.blockContextType,
    this.scalarContextType,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterPanelBuilderState();
  }
}

class _FilterPanelBuilderState
    extends _ContextProviderViewState<_FilterPanelBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  ContextProviderViewType get type => ContextProviderViewType.filter;

  @override
  Shelf? _getRelatedShelf() {
    return widget.filterModel.shelf;
  }


  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.filterModel);
  }

  @override
  BlockContextType? get blockContextType => widget.blockContextType;

  @override
  ScalarContextType? get scalarContextType => widget.scalarContextType;

  @override
  StageContextType? get stageContextType => null;

  @override
  TaskContextType? get taskContextType => null;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.filterModel.ui._setFilterPanelBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isVisible}) {
    widget.filterModel.ui._addFilterPanelWidgetState(
      widgetState: this,
      isVisible: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.filterModel.ui._removeFilterPanelWidgetState(
      widgetState: this,
    );
  }

  @override
  void executeAfterBuild() {
    widget.filterModel._afterBuildFilterPanel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // widget.filterModel._formKey = formKey;
  }

  @_FilterPanelChangeAnnotation()
  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXModuleId != null) {
      return;
    }
    //
    bool isBuilding = widget.filterModel.ui._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!isBuilding) {
      await widget.filterModel._onChangeFromFilterPanel(
        formKeyInstantValuesInUI: formKey.currentState?.instantValue ?? {},
      );
    }
  }

  @override
  @_FilterPanelChangeAnnotation()
  Widget buildContent(BuildContext context) {
    widget.filterModel.ui._setFilterPanelBuildingState(
      widgetState: this,
      isBuilding: true,
    );
    //
    return FormBuilder(
      key: formKey,
      initialValue: widget.filterModel._initialValuesForFilterPanel(),
      onChanged: _onChanged,
      child: AbsorbPointer(
        absorbing: !widget.filterModel.isEnabled(),
        child: widget.build(),
      ),
    );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.filterModel.shelf);
  }
}
