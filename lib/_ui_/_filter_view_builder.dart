part of '../flutter_artist.dart';

class _FilterViewBuilder extends _RefreshableWidget {
  final DataFilter dataFilter;

  final Widget Function() build;

  const _FilterViewBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.dataFilter,
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
    return getClassName(widget.dataFilter);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.filter;

  @override
  void addFilterFragmentWidgetState({required bool isShowing}) {
    widget.dataFilter._addFilterFragmentWidgetState(
      widgetState: this,
      isShowing: true,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.dataFilter._removeFilterFragmentWidgetState(
      widgetState: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.dataFilter._formKey = formKey;
  }

  @override
  Widget buildContent(BuildContext context) {
    __executeAfterBuild();
    //
    return FormBuilder(
      key: formKey,
      initialValue: widget.dataFilter.initFilterValue(),
      onChanged: () {
        widget.dataFilter._onChangeFromFilterView();
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.dataFilter.updateAllUIComponents();
          });
        }
      },
      child: AbsorbPointer(
        absorbing: !widget.dataFilter.isEnabled(),
        child: widget.build(),
      ),
    );
  }

  Future<void> __executeAfterBuild() async {
    // IMPORTANT: Do not remove below line:
    await Future.delayed(Duration.zero);
    //
    widget.dataFilter._onChangeFromFilterView();
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.dataFilter.shelf);
  }
}
