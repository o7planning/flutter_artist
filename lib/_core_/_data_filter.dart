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

  S? __filterSnapshotBk;

  S? _filterSnapshot;

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

  Future<_FilterSnapshotWrapper<S>> __prepareData({
    required S? suggestedFilterSnapshot,
  }) async {
    __currentTryingSnapshotId + 1;
    final int tryingSnapshotId = __currentTryingSnapshotId;
    //
    try {
      await prepareData(
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      );
      // If no error:
      S tryingSnapshot = takeSnapshot();
      __filterSnapshotsMap[tryingSnapshotId] = tryingSnapshot;
      //
      return _FilterSnapshotWrapper(
        filterSnapshotId: tryingSnapshotId,
        filterSnapshot: tryingSnapshot,
      );
    } catch (e, stackTrace) {
      // TODO: Xử lý lỗi ?????????????????????????????????????????????????????????????????????
      // TODO: Xử lý lỗi ?????????????????????????????????????????????????????????????????????
      throw _TransactionError();
    }
  }

  ///
  /// Query all Scalars and Blocks of this DataFilter if they are visible on the UI.
  ///
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  Future<bool> queryAll({
    S? suggestedFilterSnapshot,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "suggestedFilterSnapshot": suggestedFilterSnapshot,
      },
      route: null,
    );
    return await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: this,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      ),
      forceQueryScalarOpts: _scalars.map((s) => _ScalarOpt(scalar: s)).toList(),
      forceQueryBlockOpts: _blocks
          .map(
            (b) => _BlockOpt(
                block: b,
                queryType: null,
                pageable: null,
                listBehavior: null,
                suggestedSelection: null,
                postQueryBehavior: null),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
  }

  ///
  /// Query all Scalars and Blocks of this DataFilter if they are visible on the UI.
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  /// [forceBlockWithQueryOptions.block] will be queried mandatory.
  ///
  // Future<bool> _queryAllWithOverlayAndRestorable({
  //   required S? suggestedFilterSnapshot,
  //   required _BlockOpt? forceBlockWithQueryOptions,
  //   required _ScalarOpt? forceScalarWithQueryOptions,
  // }) async {
  //   return await FlutterArtist.executeTask(
  //     asyncFunction: () async {
  //       return await __queryAllIfNeedWithRestorable(
  //         suggestedFilterSnapshot: suggestedFilterSnapshot,
  //         forceBlockWithQueryOptions: null,
  //         forceScalarWithQueryOptions: null,
  //       );
  //     },
  //   );
  // }

  ///
  /// Query all Scalars and Blocks of this DataFilter if they are visible on the UI.
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  // Future<bool> __queryAllIfNeedWithRestorable({
  //   required S? suggestedFilterSnapshot,
  //   required _BlockOpt? forceBlockWithQueryOptions,
  //   required _ScalarOpt? forceScalarWithQueryOptions,
  // }) async {
  //   final List<Scalar> queryScalars = _scalars;
  //   // TODO: Kiem tra danh sach cac Block can query. ???????????????????????????????????????????????????????????????????
  //   // TODO: Loai bo cac Block con ra khoi query. ??????????????????????????????????????????????????????????????????????
  //   final List<Block> queryBlocks = _blocks;
  //   //
  //   // Start QUERY:
  //   //
  //   try {
  //     __backupAll(
  //       scalars: queryScalars,
  //       blocks: queryBlocks,
  //     );
  //     //
  //     _FilterSnapshotWrapper<S> tryingSnapshot = await __prepareData(
  //       suggestedFilterSnapshot: suggestedFilterSnapshot,
  //     );
  //     //
  //     final int tryingFilterSnapshotId = tryingSnapshot.filterSnapshotId;
  //     final S tryingFilterSnapshot = tryingSnapshot.filterSnapshot;
  //     //
  //     for (Scalar scalar in queryScalars) {
  //       bool success = await scalar.__queryThis(
  //         filterSnapshot: tryingFilterSnapshot,
  //       );
  //       if (!success) {
  //         // Throw error to restore all....
  //         throw _TransactionError();
  //       }
  //     }
  //     bool success = true;
  //     for (Block block in queryBlocks) {
  //       bool success = await block.__queryThisAndChildren(
  //         queryType: QueryType.forceQuery,
  //         listBehavior: ListBehavior.replace,
  //         filterSnapshot: tryingFilterSnapshot,
  //         postQueryBehavior: PostQueryBehavior.selectAvailableItem,
  //         suggestedSelection: null,
  //         pageable: null,
  //       );
  //       if (!success) {
  //         // Throw error to restore all....
  //         throw _TransactionError();
  //       }
  //     }
  //     //
  //     __applyNewStateAll(
  //       scalars: queryScalars,
  //       blocks: queryBlocks,
  //     );
  //     //
  //     return success;
  //   } catch (e) {
  //     // Restore all...
  //     __restoreAll(
  //       scalars: queryScalars,
  //       blocks: queryBlocks,
  //     );
  //     return false;
  //   }
  // }

  // ***************************************************************************
  // *** BACKUP, RESTORE, APPLY ***
  // ***************************************************************************

  void __backupAll({
    required List<Scalar> scalars,
    required List<Block> blocks,
  }) {
    for (Scalar scalar in scalars) {
      scalar._backup();
    }
    for (Block block in blocks) {
      block._backupAll();
    }
  }

  void __restoreAll({
    required List<Scalar> scalars,
    required List<Block> blocks,
  }) {
    for (Scalar scalar in scalars) {
      scalar._restore();
    }
    for (Block block in blocks) {
      block._restoreAll();
    }
  }

  void __applyNewStateAll({
    required List<Scalar> scalars,
    required List<Block> blocks,
  }) {
    for (Scalar scalar in scalars) {
      scalar._applyNewStateAll();
    }
    for (Block block in blocks) {
      block._applyNewStateAll();
    }
  }

  void _backup() {
    __filterSnapshotBk = _filterSnapshot;
  }

  void _restore() {
    _filterSnapshot = __filterSnapshotBk;
    //
    for (Restorable bk in restorableCriteria) {
      bk.restore();
    }
  }

  void _applyNewState() {
    __filterSnapshotBk = null;
    for (Restorable bk in restorableCriteria) {
      bk.applyNewState();
    }
  }

  // ***************************************************************************
  // *** UI COMPONENTS ***
  // ***************************************************************************

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

  void showErrorSnackBar({
    required String message,
    List<String>? errorDetails,
  }) {
    if (_blocks.isNotEmpty) {
      FlutterArtist.adapter.showErrorSnackBar(
        message: message,
        errorDetails: errorDetails,
      );
    }
  }
}
