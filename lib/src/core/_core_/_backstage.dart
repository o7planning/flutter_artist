part of 'core.dart';

class _Backstage {
  DefermentInfo? _defermentInfo;

  /// Flag indicating that shelf reactions are suppressed for a single dispatch cycle.
  bool _deferOnce = false;

  final drawer = _DrawerController();
  final endDrawer = _EndDrawerController();

  _Backstage();

  /// Indicates whether reaction processing across shelves is currently suspended.
  bool get isReactionDeferred {
    if (_deferOnce) {
      return true;
    }
    return _defermentInfo != null;
  }

  /// Manually triggers a one-off reaction deferral for the immediate next event cycle.
  void _deferReactionsOnce() {
    _deferOnce = true;
  }

  /// Consumes and resets the single-cycle deferral flag after an event pass.
  void _consumeSingleDeferral() {
    _deferOnce = false;
  }

  // ***************************************************************************
  // DEFERMENT LIFECYCLE MANAGEMENT
  // ***************************************************************************

  void _deferReactions({
    required DefermentSource defermentSource,
    required Set<Type> excludeShelfTypes,
  }) {
    _defermentInfo = DefermentInfo(
      defermentSource: defermentSource,
      excludeShelfTypes: excludeShelfTypes,
    );
  }

  void __resumeReactions({
    required ExecutionTrace executionTrace,
  }) {
    if (_defermentInfo == null) {
      return;
    }
    _deferOnce = false;
    _defermentInfo = null;

    // Dispatch queued reaction execution units once overlay is dismissed
    Future.delayed(
      Duration.zero,
      () {
        for (String shelfName in FlutterArtist.storage._shelfMap.keys) {
          Shelf reactionShelf = FlutterArtist.storage._shelfMap[shelfName]!;
          if (reactionShelf._hasReactionBookmark()) {
            reactionShelf._addShelfExternalReactionExecutionUnit(
              executionTrace: executionTrace,
            );
          }
        }
        FlutterArtist.executor._executeExecutionUnitQueue();
      },
    );
  }

  // ***************************************************************************
  // OVERLAY METHODS WITH REACTION DEFERRAL
  // ***************************************************************************

  Future<DialogDeferralResult<V>> showDialogWithDeferredReactions<V>({
    required Set<Type> excludeShelfTypes,
    required String path,
    required FaRouteBuilder builder,
  }) async {
    if (_defermentInfo != null) {
      return DialogDeferralResult<V>.fail();
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'showDialogWithDeferredReactions',
      parameters: null,
      isLibMethod: true,
    );
    try {
      _deferReactions(
        defermentSource: DefermentSource.dialog,
        excludeShelfTypes: excludeShelfTypes,
      );
      V? value = await FlutterArtist.router.showDialog(path, builder: builder);
      return DialogDeferralResult.success(dialogValue: value);
    } finally {
      __resumeReactions(executionTrace: executionTrace);
    }
  }

  Future<void> openDrawerWithDeferredReactions(
    BuildContext context, {
    required Set<Type> excludeShelfTypes,
    bool showSuggestionIfNeed = true,
  }) async {
    if (_defermentInfo != null) {
      return;
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openDrawerWithDeferredReactions',
      parameters: null,
      isLibMethod: true,
    );
    Scaffold.of(context).openDrawer();

    _deferReactions(
      defermentSource: DefermentSource.drawer,
      excludeShelfTypes: excludeShelfTypes,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) => FlutterArtist.backstage.drawer.isOpen == true,
      ),
    );
    __resumeReactions(executionTrace: executionTrace);
  }

  Future<void> openEndDrawerWithDeferredReactions(
    BuildContext context, {
    required Set<Type> excludeShelfTypes,
    bool showSuggestionIfNeed = true,
  }) async {
    if (_defermentInfo != null) {
      return;
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: 'openEndDrawerWithDeferredReactions',
      parameters: null,
      isLibMethod: true,
    );
    Scaffold.of(context).openEndDrawer();

    _deferReactions(
      defermentSource: DefermentSource.endDrawer,
      excludeShelfTypes: excludeShelfTypes,
    );
    await Future.delayed(const Duration(milliseconds: 100));
    await Future.doWhile(
      () => Future.delayed(const Duration(milliseconds: 1)).then(
        (_) => FlutterArtist.backstage.endDrawer.isOpen == true,
      ),
    );
    __resumeReactions(executionTrace: executionTrace);
  }
}

class DefermentInfo {
  final DefermentSource defermentSource;
  final Set<Type> excludeShelfTypes;

  DefermentInfo({
    required this.defermentSource,
    required this.excludeShelfTypes,
  });
}
