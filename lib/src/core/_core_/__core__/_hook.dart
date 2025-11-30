part of '../core.dart';

abstract class Hook extends _Core {
  late final Shelf shelf;

  final String name;
  final HookConfig config;

  late final ui = _HookUIComponents(hook: this);

  Hook({
    required this.name,
    HookConfig config = const HookConfig(),
  }) : config = config.copy();

  // ***************************************************************************

  XHook _createXHook({required XShelf xShelf}) {
    return XHook._(
      hook: this,
      xShelf: xShelf,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> callApiLogic() async {
    // Override me.
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> doLogic() async {
    XShelf xShelf = _XShelfHook(hook: this);
    xShelf._initHookTaskUnit();
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireHookHidden() {
    switch (config.hiddenBehavior) {
      case HookHiddenBehavior.none:
        break;
    }
  }
}
