part of '../flutter_artist.dart';

abstract class DataFilter<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _XBase {
  late final Shelf shelf;

  late final String name;

  String get id {
    return "data-filter > ${shelf.name} > $name";
  }

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

  FILTER_CRITERIA? _filterCriteria;

  FILTER_CRITERIA? get filterCriteria => _filterCriteria;

  List<Restorable> get restorableCriteria;

// ***************************************************************************
  // ***************************************************************************

  final Map<_RefreshableWidgetState, bool> _filterFragmentWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after calling [prepareData()] method if there are no errors.
  ///
  FILTER_CRITERIA createFilterCriteria();

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  Future<FILTER_CRITERIA?> _prepareData({
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
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return null;
    }
    try {
      // If no error:
      FILTER_CRITERIA newCriteria = createFilterCriteria();
      _filterCriteria = newCriteria;
      __filterCriteriasMap[tryingCriteriaId] = newCriteria;
      //
      return newCriteria;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "createFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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
    _XShelf xShelf= await shelf._queryAll(
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
    // TODO: Xem lai.
    return true;
  }

  // ***************************************************************************
  // *** UI COMPONENTS ***
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return _filterFragmentWidgetStates.isNotEmpty;
  }

  // ***************************************************************************
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

  // ***************************************************************************
  // ***************************************************************************

  void _addFilterFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _filterFragmentWidgetStates[widgetState] = isShowing;
    bool activeCURRENT = hasActiveUIComponent();

    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      // TODO: (Kiem tra phuong thuc cung ten trong Block).
      // block._fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeFilterFragmentWidgetState({
    required State widgetState,
  }) {
    _filterFragmentWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateAllUIComponents() {
    for (_RefreshableWidgetState widgetState in [
      ..._filterFragmentWidgetStates.keys
    ]) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }
}
