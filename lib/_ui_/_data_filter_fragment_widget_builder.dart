part of '../flutter_artist.dart';

class DataFilterFragmentWidgetBuilder extends _RefreshableWidget {
  final DataFilter dataFilter;

  final Widget Function() build;

  const DataFilterFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.dataFilter,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _DataFilterFragmentWidgetBuilderState();
  }
}

class _DataFilterFragmentWidgetBuilderState
    extends _RefreshableWidgetState<DataFilterFragmentWidgetBuilder> {
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
      isShowing: isShowing,
    );
  }

  @override
  void removeFilterFragmentWidgetState() {
    widget.dataFilter._removeFilterFragmentWidgetState(widgetState: this);
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.dataFilter.shelf);
  }
}
