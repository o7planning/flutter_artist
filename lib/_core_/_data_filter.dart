part of '../flutter_artist.dart';

abstract class DataFilter<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _XBase {
  late final Shelf shelf;

  late final String name;

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

  FILTER_CRITERIA? get currentSuccessFilterCriteria {
    return __currentSuccessCriteriaId == null
        ? null
        : __filterCriteriasMap[__currentSuccessCriteriaId];
  }

  FILTER_CRITERIA? __filterCriteriaBk;

  FILTER_CRITERIA? _filterCriteria;

  List<Restorable> get restorableCriteria;

  final Map<_WidgetState, bool> _filterFragmentWidgetStates = {};

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getFilterInputTypeAsString()}, ${getFilterCriteriaTypeAsString()}>";
  }

  String getFilterCriteriaTypeAsString() {
    return FILTER_CRITERIA.toString();
  }

  String getFilterInputTypeAsString() {
    return FILTER_INPUT.toString();
  }

  ///
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
  ///
  FILTER_CRITERIA createFilterCriteria();

  ///
  /// ```Dart
  /// Future<void> prepareData({MyFilterInput? filterInput}) {
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
    FILTER_INPUT? filterInput,
  });

  Future<_FilterCriteriaWrapper<FILTER_CRITERIA>> __prepareData({
    required FILTER_INPUT? filterInput,
  }) async {
    __currentTryingCriteriaId + 1;
    final int tryingCriteriaId = __currentTryingCriteriaId;
    //
    try {
      // This method may throw ApiError.
      await prepareData(
        filterInput: filterInput,
      );
      // If no error:
      FILTER_CRITERIA tryingCriteria = createFilterCriteria();
      __filterCriteriasMap[tryingCriteriaId] = tryingCriteria;
      //
      return _FilterCriteriaWrapper(
        filterCriteriaId: tryingCriteriaId,
        filterCriteria: tryingCriteria,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiQuery",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      throw _TransactionError();
    }
  }

  ///
  /// Query all Scalars and Blocks of this DataFilter if they are visible on the UI.
  ///
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  Future<bool> queryAll({
    FILTER_INPUT? filterInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "filterInput": filterInput,
      },
      navigate: null,
    );
    return await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: this,
        filterInput: filterInput,
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

  // ***************************************************************************
  // *** BACKUP, RESTORE, APPLY ***
  // ***************************************************************************

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

  bool hasActiveUIComponent() {
    for (State widgetState in _filterFragmentWidgetStates.keys) {
      bool isShowing = _filterFragmentWidgetStates[widgetState] ?? false;
      if (isShowing && widgetState.mounted) {
        return true;
      }
    }
    return false;
  }

  void _addFilterFragmentWidgetState({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _filterFragmentWidgetStates[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removeFilterFragmentWidgetState({required State widgetState}) {
    _filterFragmentWidgetStates.remove(widgetState);
    FlutterArtist.storage._checkToRemoveShelf(shelf);
  }

  void updateAllUIComponents() {
    for (_WidgetState widgetState in [..._filterFragmentWidgetStates.keys]) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  @override
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
