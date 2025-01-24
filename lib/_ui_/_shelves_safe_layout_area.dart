part of '../flutter_artist.dart';

class ShelvesSafeLayoutArea extends _RefreshableWidget {
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

class _ShelvesSafeLayoutAreaState extends _RefreshableWidgetState<ShelvesSafeLayoutArea> {
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
  void addFilterFragmentWidgetState({required bool isShowing}) {
    for (Shelf shelf in widget.shelves) {
      shelf._addShelfWidgetState(
        widgetState: this,
        isShowing: isShowing,
      );
    }
  }

  @override
  void removeFilterFragmentWidgetState() {
    for (Shelf shelf in widget.shelves) {
      shelf._removeShelfWidgetState(
        widgetState: this,
      );
    }
  }

  @override
  void checkAndFreeMemory() {
    for (Shelf shelf in widget.shelves) {
      FlutterArtist.storage._checkToRemoveShelf(shelf);
    }
  }
}
