part of '../flutter_artist.dart';

class ShelvesSafeLayoutArea extends _StatefulWidget {
  final List<Shelf> shelves;
  final Widget Function() build;

  const ShelvesSafeLayoutArea({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.shelves,
    required this.build,
  }) : assert(shelves.length > 0);

  @override
  State<StatefulWidget> createState() {
    return _ShelvesSafeLayoutAreaState();
  }
}

class _ShelvesSafeLayoutAreaState extends _WidgetState<ShelvesSafeLayoutArea> {
  late final String keyId;

  @override
  String get locationInfo => getClassName(widget.ownerClassInstance);

  @override
  String get description {
    return widget.description == null || widget.description!.trim().isEmpty
        ? "(ShelvesSafeLayoutArea)"
        : widget.description!;
  }

  @override
  WidgetStateType get type => WidgetStateType.shelfFragment;

  @override
  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //
    keyId = _generateVisibilityDetectorId(prefix: "shelves");
    //
    _addWidgetStateListener(isShowing: true);
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
          ? widget.build()
          : _DevContainer(
              child: widget.build(),
            ),
    );
  }

  void _addWidgetStateListener({required bool isShowing}) {
    for (Shelf shelf in widget.shelves) {
      shelf._addWidgetStateListener(
        widgetState: this,
        isShowing: isShowing,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (Shelf shelf in widget.shelves) {
      shelf._removeWidgetStateListener(widgetState: this);
    }
  }
}
