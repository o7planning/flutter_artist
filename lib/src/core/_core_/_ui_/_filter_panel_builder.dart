part of '../core.dart';

// bool _lockChangeEvent1 = false;

class _FilterPanelBuilder extends _RefreshableWidget {
  final FilterModel filterModel;

  final Widget Function() build;

  const _FilterPanelBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.filterModel,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterPanelBuilderState();
  }
}

class _FilterPanelBuilderState
    extends _RefreshableWidgetState<_FilterPanelBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.filterModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.filter;

  @override
  bool get isScalarRepresentative {
    return false;
  }

  @override
  bool get isBlockRepresentative {
    return false;
  }

  @override
  bool get isItemRepresentative {
    return false;
  }

  @override
  bool get isFormRepresentative {
    return false;
  }

  @override
  bool get isHookRepresentative {
    return false;
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.filterModel.ui._setFilterPanelBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.filterModel.ui._addFilterFragmentWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.filterModel.ui._removeFilterFragmentWidgetState(
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
    widget.filterModel._formKey = formKey;
  }

  @_FilterPanelChangeAnnotation()
  Future<void> _onChanged() async {
    if (FlutterArtist.executor.executingXShelfId != null) {
      return;
    }
    //
    bool isBuilding = widget.filterModel.ui._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!isBuilding) {
      await widget.filterModel._onChangeFromFilterPanel();
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
