part of '../flutter_artist.dart';

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
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.filterModel._addFilterFragmentWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.filterModel._removeFilterFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.filterModel._formKey = formKey;
  }

  @override
  Widget buildContent(BuildContext context) {
    __executeAfterBuild();
    //
    return FormBuilder(
      key: formKey,
      initialValue: widget.filterModel.initFilterValue(),
      onChanged: () {
        widget.filterModel._onChangeFromFilterView();
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.filterModel.updateAllUIComponents();
          });
        }
      },
      child: AbsorbPointer(
        absorbing: !widget.filterModel.isEnabled(),
        child: widget.build(),
      ),
    );
  }

  Future<void> __executeAfterBuild() async {
    // IMPORTANT: Do not remove below line:
    await Future.delayed(Duration.zero);
    //
    widget.filterModel._onChangeFromFilterView();
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.filterModel.shelf);
  }
}
