part of '../flutter_artist.dart';

// bool _lockChangeEvent1 = false;

class _FilterViewBuilder extends _RefreshableWidget {
  final FilterModel filterModel;

  final Widget Function() build;

  const _FilterViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.filterModel,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterViewBuilderState();
  }
}

class _FilterViewBuilderState
    extends _RefreshableWidgetState<_FilterViewBuilder> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.filterModel);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.filter;

  @override
  void setBuildingState({required bool isBuilding}) {
    widget.filterModel._setFilterViewBuildingState(
      widgetState: this,
      isBuilding: isBuilding,
    );
  }

  @override
  void addWidgetState({required bool isShowing}) {
    widget.filterModel._addFilterFragmentWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeWidgetState() {
    widget.filterModel._removeFilterFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void executeAfterBuild() {
    widget.filterModel._afterBuildFilterView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.filterModel._formKey = formKey;
  }

  bool _getLockChangeEven() {
    return _lockChangeEvent;
  }

  Future<void> _onChange() async {
    bool lockChange = widget.filterModel._lockChange;
    bool isBuilding = widget.filterModel._isWidgetStateBuilding(
      widgetState: this,
    );
    if (!lockChange && !isBuilding) {
      await widget.filterModel._onChangeFromFilterView();
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    widget.filterModel
        ._setFilterViewBuildingState(widgetState: this, isBuilding: true,);
    //
    return FormBuilder(
      key: formKey,
      initialValue: widget.filterModel._initFilterValue(),
      onChanged: _onChange,
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
