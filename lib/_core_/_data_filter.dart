part of '../flutter_artist.dart';

abstract class DataFilter<
    SUGGESTED_CRITERIA extends SuggestedCriteria, //
    FILTER_CRITERIA extends EmptyFilterCriteria> {
  late final String name;

  late final Shelf shelf;

  final List<Block> _blocks = [];

  List<Block> get blocks => [..._blocks];

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  int __currentTryingCriteriaId = 0;
  int? __currentSuccessCriteriaId;

  int? get currentSuccessCriteriaId => __currentSuccessCriteriaId;

  ///
  /// Map<CriteriaId, EmptyFilterCriteria>
  ///
  final Map<int, FILTER_CRITERIA> __filterCriteriasMap = {};

  FILTER_CRITERIA? get currentSuccessEmptyFilterCriteria {
    return __currentSuccessCriteriaId == null
        ? null
        : __filterCriteriasMap[__currentSuccessCriteriaId];
  }

  FILTER_CRITERIA? __filterCriteriaBk;

  FILTER_CRITERIA? _filterCriteria;

  List<Restorable> get restorableCriteria;

  final Map<_WidgetState, bool> _widgetStateListeners = {};

  String getEmptyFilterCriteriaTypeAsString() {
    return FILTER_CRITERIA.toString();
  }

  String getSuggestedCriteriaTypeAsString() {
    return SUGGESTED_CRITERIA.toString();
  }

  ///
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
  ///
  FILTER_CRITERIA createCriteria();

  ///
  /// ```Dart
  /// Future<void> prepareData({MySuggestedCriteria? suggestedCriteria}) {
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
    SUGGESTED_CRITERIA? suggestedCriteria,
  });

  Future<_EmptyFilterCriteriaWrapper<FILTER_CRITERIA>> __prepareData({
    required SUGGESTED_CRITERIA? suggestedCriteria,
  }) async {
    __currentTryingCriteriaId + 1;
    final int tryingCriteriaId = __currentTryingCriteriaId;
    //
    try {
      await prepareData(
        suggestedCriteria: suggestedCriteria,
      );
      // If no error:
      FILTER_CRITERIA tryingCriteria = createCriteria();
      __filterCriteriasMap[tryingCriteriaId] = tryingCriteria;
      //
      return _EmptyFilterCriteriaWrapper(
        filterCriteriaId: tryingCriteriaId,
        filterCriteria: tryingCriteria,
      );
    } catch (e, stackTrace) {
      print(stackTrace);
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
    SUGGESTED_CRITERIA? suggestedCriteria,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "suggestedCriteria": suggestedCriteria,
      },
      route: null,
    );
    return await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: this,
        suggestedCriteria: suggestedCriteria,
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
  //   required S? suggestedCriteria,
  //   required _BlockOpt? forceBlockWithQueryOptions,
  //   required _ScalarOpt? forceScalarWithQueryOptions,
  // }) async {
  //   return await FlutterArtist.executeTask(
  //     asyncFunction: () async {
  //       return await __queryAllIfNeedWithRestorable(
  //         suggestedCriteria: suggestedCriteria,
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
  //   required S? suggestedCriteria,
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
  //     _EmptyFilterCriteriaWrapper<S> tryingCriteria = await __prepareData(
  //       suggestedCriteria: suggestedCriteria,
  //     );
  //     //
  //     final int tryingEmptyFilterCriteriaId = tryingCriteria.filterCriteriaId;
  //     final S tryingEmptyFilterCriteria = tryingCriteria.filterCriteria;
  //     //
  //     for (Scalar scalar in queryScalars) {
  //       bool success = await scalar.__queryThis(
  //         filterCriteria: tryingEmptyFilterCriteria,
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
  //         filterCriteria: tryingEmptyFilterCriteria,
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
    __filterCriteriaBk = _filterCriteria;
  }

  void _restore() {
    _filterCriteria = __filterCriteriaBk;
    //
    for (Restorable bk in restorableCriteria) {
      bk.restore();
    }
  }

  void _applyNewState() {
    __filterCriteriaBk = null;
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

  void updateAllUIComponents() {
    _updateWidgets();
  }

  void _updateWidgets() {
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
