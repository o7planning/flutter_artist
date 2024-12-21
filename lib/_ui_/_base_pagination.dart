part of '../flutter_artist.dart';

abstract class BasePagination extends StatefulWidget {
  final Block block;
  final String? description;
  final Object ownerClassInstance;

  const BasePagination({
    super.key,
    required this.block,
    required this.description,
    required this.ownerClassInstance,
  });

  Widget build();

  @override
  State<StatefulWidget> createState() {
    return _BasePaginationState();
  }
}

class _BasePaginationState extends _WidgetState<BasePagination> {
  late final String keyId;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(keyId),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        _addPaginationWidgetStateListener(isShowing: visiblePercentage > 0);
      },
      child: showMode == ShowMode.production
          ? _buildMain()
          : _DevContainer(
              child: _buildMain(),
            ),
    );
  }

  Widget _buildMain() {
    return widget.build();
  }

  void _addPaginationWidgetStateListener({required bool isShowing}) {
    widget.block._addPaginationWidgetStateListener(
      formWidgetState: this,
      isShowing: isShowing,
    );
  }

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "${getClassName(widget.block)} (Pagination)"
        : widget.description!;
  }

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  WidgetStateType get type => WidgetStateType.pagination;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    keyId = _generateVisibilityDetectorId(
        prefix: "ControlBar-${getClassName(widget.block)}");
    _addPaginationWidgetStateListener(isShowing: true);
  }

  @override
  void dispose() {
    super.dispose();
    widget.block._removePaginationWidgetStateListener(
      formWidgetState: this,
    );
  }
}
