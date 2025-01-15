part of '../flutter_artist.dart';

abstract class DataFilter<S extends FilterSnapshot> {
  late final String name;

  late final Shelf shelf;

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  int __currentTryingSnapshotId = 0;
  int? __currentSuccessSnapshotId;

  int? get currentSuccessSnapshotId => __currentSuccessSnapshotId;

  ///
  /// Map<SnapshotId, FilterSnapshot>
  ///
  final Map<int, S> __filterSnapshotsMap = {};

  S? get currentSuccessFilterSnapshot {
    return __currentSuccessSnapshotId == null
        ? null
        : __filterSnapshotsMap[__currentSuccessSnapshotId];
  }

  S? _currentSnapshot;

  List<Restorable> get restorableCriteria;

  final Map<_WidgetState, bool> _widgetStateListeners = {};

  String getFilterSnapshotTypeAsString() {
    return S.toString();
  }

  ///
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
  ///
  S takeSnapshot();

  ///
  /// This method is always called whenever the [Block.queryXxx()] method is called.
  ///
  /// When calling [DataFilter.queryBlock()] method from outside you can pass parameter [suggestedFilterSnapshot].
  /// This parameter will always be null if you call the [Block.queryXxx()] method. (??????)
  ///
  /// ```Dart
  /// Future<void> prepareData({MyFilterSnapshot? suggestedFilterSnapshot}) {
  ///     ApiResult<dynamic>? r1 = await callYourApi1();
  ///     // Throws ApiError if r1.isError()
  ///     r1?.throwIfError();
  ///
  ///     ApiResult<dynamic>? r2 = await callYourApi2();
  ///     // Throws ApiError if r2.isError()
  ///     r2?.throwIfError();
  /// }
  /// ```
  ///
  Future<void> prepareData({
    S? suggestedFilterSnapshot,
  });

  Future<_TryingFilter<S>?> __prepareData({
    S? suggestedFilterSnapshot,
  }) async {
    try {
      __currentTryingSnapshotId + 1;
      final int tryingSnapshotId = __currentTryingSnapshotId;
      //
      await prepareData(
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      );
      // If no error:
      S tryingSnapshot = takeSnapshot();
      __filterSnapshotsMap[tryingSnapshotId] = tryingSnapshot;
      return _TryingFilter(
        tryingFilterSnapshotId: tryingSnapshotId,
        tryingFilterSnapshot: tryingSnapshot,
      );
    } catch (e, stackTrace) {
      // TODO: Xu ly Error!
      return null;
    }
  }

  Future<bool> queryBlocks({
    S? suggestedFilterSnapshot,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "queryBlocks",
      parameters: {
        "suggestedFilterSnapshot": suggestedFilterSnapshot,
      },
      route: null,
    );
    //
    // _TryingFilter<S>? tryingFilter = await __prepareData(
    //   suggestedFilterSnapshot: suggestedFilterSnapshot,
    // );
    // //
    // if (tryingFilter == null) {
    //   return false;
    // }
    // final int tryingFilterSnapshotId = tryingFilter.tryingFilterSnapshotId;
    // final S tryingFilterSnapshot = tryingFilter.tryingFilterSnapshot;
    //
    for (Scalar scalar in _scalars) {
      scalar.query();
    }
    bool success = true;
    for (Block block in _blocks) {
      bool s = await block.query(
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      );
      if (!s) {
        success = s;
      }
    }
    return success;
  }

  bool hasActiveFilterFragmentWidget() {
    _removeUnmountedWidgetStates(_widgetStateListeners);

    for (State widgetState in _widgetStateListeners.keys) {
      bool isShowing = _widgetStateListeners[widgetState] ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool activeOnly,
  }) {
    _removeUnmountedWidgetStates(_widgetStateListeners);

    Map<_WidgetState, bool> ret = {};
    Map<_WidgetState, bool> m = {..._widgetStateListeners};
    for (_WidgetState key in m.keys) {
      if (key.mounted) {
        if (!activeOnly || m[key]!) {
          ret[key] = m[key]!;
        }
      }
    }
    return ret;
  }

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _widgetStateListeners[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removeWidgetStateListener({required State widgetState}) {
    _widgetStateListeners.remove(widgetState);
    FlutterArtist.storage._checkToRemoveShelf(shelf);
  }

  void updateWidgets() {
    _removeUnmountedWidgetStates(_widgetStateListeners);
    for (_WidgetState widgetState in [..._widgetStateListeners.keys]) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void _restore() {
    for (Restorable bk in restorableCriteria) {
      bk.restore();
    }
  }

  void _applyNewState() {
    for (Restorable bk in restorableCriteria) {
      bk.applyNewState();
    }
  }

  void showErrorSnackbar({
    required String message,
    List<String>? errorDetails,
  }) {
    if (_blocks.isNotEmpty) {
      FlutterArtist.adapter.showErrorSnackbar(
        message: message,
        errorDetails: errorDetails,
      );
    }
  }
}
