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
  @override
  String getWidgetOwnerClassName() {
    return "ShelvesSafeLayoutArea";
  }

  @override
  WidgetStateType get type => WidgetStateType.shelfFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetStateListener({required bool isShowing}) {
    for (Shelf shelf in widget.shelves) {
      shelf._addWidgetStateListener(
        widgetState: this,
        isShowing: isShowing,
      );
    }
  }

  @override
  void removeWidgetStateListener() {
    for (Shelf shelf in widget.shelves) {
      shelf._removeWidgetStateListener(
        widgetState: this,
      );
    }
  }
}
