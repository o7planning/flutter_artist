part of '../flutter_artist.dart';

class ZilchFragmentWidgetBuilder extends _RefreshableWidget {
  final Zilch zilch;
  final Widget Function() build;

  const ZilchFragmentWidgetBuilder({
    super.key,
    required super.ownerClassInstance,
    required super.description,
    required this.zilch,
    required this.build,
  });

  @override
  State<StatefulWidget> createState() {
    return _VoidFragmentWidgetBuilderState();
  }
}

class _VoidFragmentWidgetBuilderState
    extends _RefreshableWidgetState<ZilchFragmentWidgetBuilder> {
  @override
  String getWidgetOwnerClassName() {
    return getClassName(widget.zilch);
  }

  @override
  RefreshableWidgetType get type => RefreshableWidgetType.zilchFragment;

  @override
  Widget buildContent(BuildContext context) {
    return widget.build();
  }

  @override
  void addWidgetState({required bool isShowing}) {
    // widget.zilch._addVoidFragmentWidgetState(
    //   widgetState: this,
    //   isShowing: isShowing,
    // );
  }

  @override
  void removeWidgetState() {
    // widget.zilch._removeVoidFragmentWidgetState(
    //   widgetState: this,
    // );
  }

  @override
  void checkAndFreeMemory() {
    FlutterArtist.storage._checkToRemoveShelf(widget.zilch.shelf);
  }

  @override
  void executeAfterBuild() {
    // Do nothing.
  }

  @override
  void setBuildingState({required bool isBuilding}) {
    //
  }
}
