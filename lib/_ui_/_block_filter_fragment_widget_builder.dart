part of '../flutter_artist.dart';

class DataFilterFragmentWidgetBuilder extends StatefulWidget {
  final DataFilter dataFilter;
  final Object ownerClassInstance;
  final String? description;
  final Widget Function(DataFilter dataFlr) build;

  const DataFilterFragmentWidgetBuilder({
    super.key,
    required this.ownerClassInstance,
    required this.description,
    required this.dataFilter,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _DataFilterFragmentWidgetBuilderState();
  }
}

class _DataFilterFragmentWidgetBuilderState
    extends _WidgetState<DataFilterFragmentWidgetBuilder> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.dataFilter)} (Filter)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.filter;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(
      prefix: getClassName(widget.dataFilter),
    );
    //
    _addWidgetStateListener(isShowing: true);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dataFilter._removeWidgetStateListener(widgetState: this);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? widget.build(widget.dataFilter)
          : _DevContainer(
              child: widget.build(widget.dataFilter),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    widget.dataFilter
        ._addWidgetStateListener(widgetState: this, isShowing: isShowing);
  }
}
