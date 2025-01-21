part of '../flutter_artist.dart';

abstract class Shelf extends _XBase {
  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All dataFilters including the default dataFilter.
  final List<DataFilter> _allDataFilters = [];

  // All blockForms.
  final List<BlockForm> _allBlockForms = [];

  final Map<String, Scalar> __scalarMap = {};

  final List<Scalar> __scalars = [];

  List<Scalar> get scalars => [...__scalars];

  final Map<String, Block> __blockMap = {};

  final List<Block> __rootBlocks = [];

  bool _isStructError = false;

  String? _structError;

  bool get isStructError => _isStructError;

  String? get structError => _structError;

  List<Block> get rootBlocks => [...__rootBlocks];

  int __lastTransactionNumber = 0;

  int __transactionId = 0;

  final List<Block> __lazyBlocksToQuery = [];

  bool _queryLocked = false;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  final Map<_WidgetState, bool> _shelfWidgetStateListeners = {};

  Shelf() {
    __onInit();
  }

  ///
  /// Very Dangerous Method. Call Internal only.
  ///
  String ___registerError(String message) {
    FlutterArtist.storage.__clear();
    //
    return "\n*********************************************************************************************\n"
        "$message"
        "\n\n  *** You may need to restart the application after editing the code. ***"
        "\n*********************************************************************************************\n";
  }

  void __onInit() {
    _shelfStruct = registerStructure();

    for (String dataFilterName in _shelfStruct.dataFilters.keys) {
      DataFilter dataFilter = _shelfStruct.dataFilters[dataFilterName]!;
      dataFilter.name = dataFilterName;
      dataFilter.shelf = this;
      //
      _allDataFilters.add(dataFilter);
    }

    List<Scalar> scalars = _shelfStruct.scalars;

    for (Scalar scalar in scalars) {
      if (__scalarMap.containsKey(scalar.name)) {
        throw ___registerError(
            "Duplicated Scalar '${scalar.name}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      } else {
        __scalarMap[scalar.name] = scalar;
      }
      scalar.shelf = this;
      __scalars.add(scalar);
      //
      if (scalar.registerDataFilterName != null) {
        DataFilter? dataFilter =
            _shelfStruct.dataFilters[scalar.registerDataFilterName!];
        if (dataFilter == null) {
          throw ___registerError(
              "DataFilter not found '${scalar.registerDataFilterName}' in '${getClassName(this)}'\n"
              "Double-check ${getClassName(this)}.registerStructure() method");
        }
        //
        const Type filterInputType = FilterInput;
        final String filterInputBase = filterInputType.toString();
        final String filterInputBF = dataFilter.getFilterInputTypeAsString();
        final String filterInputB = scalar.getFilterInputTypeAsString();
        //
        if (filterInputBF == filterInputBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterInputBase' class \n"
              "or use the 'EmptyFilterInput' class to use in the '${getClassName(dataFilter)}' declaration \n\n"
              " >> Currently, ${getClassName(dataFilter)}<FILTER_INPUT> = <$filterInputBF>");
        }
        //
        if (filterInputBF != filterInputB) {
          throw ___registerError(
              "The Scalar and its Filter-Input must have the same FILTER_INPUT type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_INPUT> = <$filterInputB> \n"
              " >> ${getClassName(dataFilter)}<FILTER_INPUT> = <$filterInputBF>");
        }
        // ----------------
        const Type filterCriteriaType = FilterCriteria;
        final String filterCriteriaBase = filterCriteriaType.toString();
        final String filterCriteriaBF =
            dataFilter.getFilterCriteriaTypeAsString();
        final String filterCriteriaB = scalar.getFilterCriteriaTypeAsString();
        //
        if (filterCriteriaBF == filterCriteriaBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterCriteriaBase' class \n"
              "or use the 'EmptyFilterCriteria' class to use in the '${getClassName(dataFilter)}' declaration \n\n"
              " >> Currently, ${getClassName(dataFilter)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        if (filterCriteriaBF != filterCriteriaB) {
          throw ___registerError(
              "The Scalar and its Data-Filter must have the same FILTER_CRITERIA type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
              " >> ${getClassName(dataFilter)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        dataFilter._scalars.add(scalar);
        scalar._registeredOrDefaultDataFilter = dataFilter;
      } else {
        // Default DataFilter.
        DataFilter defaultDataFilter = _DefaultDataFilter(
          name: "${scalar.name}-@-default-scalar-data-filter",
          shelf: this,
        );
        defaultDataFilter._scalars.add(scalar);
        scalar._registeredOrDefaultDataFilter = defaultDataFilter;
        //
        _allDataFilters.add(defaultDataFilter);
        //
        const Type emptyFilterCriteriaType = EmptyFilterCriteria;
        final String filterCriteriaEmpty = emptyFilterCriteriaType.toString();
        final String filterCriteriaB = scalar.getFilterCriteriaTypeAsString();
        //
        if (filterCriteriaB != filterCriteriaEmpty) {
          throw ___registerError(
              "FILTER_CRITERIA of '${getClassName(scalar)}' scalar must be '$filterCriteriaEmpty' "
              "because this scalar does not have a DATA_FILTER. \n\n"
              " >> Currently, ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB>");
        }
      }
    }

    List<Block> rootBlocks = _shelfStruct.blocks;
    for (Block rootBlock in rootBlocks) {
      rootBlock.parent = null;
      __rootBlocks.add(rootBlock);
      __registerBlockCascade(rootBlock);
    }
  }

  void __registerBlockCascade(Block block) {
    if (__blockMap.containsKey(block.name)) {
      throw ___registerError(
          "Duplicated block '${block.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.registerStructure() method");
    } else {
      __blockMap[block.name] = block;
      if (block.blockForm != null) {
        _allBlockForms.add(block.blockForm!);
      }
    }
    //
    block.shelf = this;
    if (block.registerDataFilterName != null) {
      DataFilter? dataFilter =
          _shelfStruct.dataFilters[block.registerDataFilterName!];
      if (dataFilter == null) {
        throw ___registerError(
            "DataFilter not found '${block.registerDataFilterName}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      }
      //
      //
      const Type filterInputType = FilterInput;
      final String filterInputBase = filterInputType.toString();
      final String filterInputBF = dataFilter.getFilterInputTypeAsString();
      final String filterInputB = block.getFilterInputTypeAsString();
      //
      if (filterInputBF == filterInputBase) {
        throw ___registerError(
            "You need to create your own class that extends the '$filterInputBase' class \n"
            "or use the 'EmptyFilterInput' class to use in the '${getClassName(dataFilter)}' declaration \n\n"
            " >> Currently, ${getClassName(dataFilter)}<FILTER_INPUT> = <$filterInputBF>");
      }
      //
      if (filterInputBF != filterInputB) {
        throw ___registerError(
            "The Scalar and its Filter-Input must have the same FILTER_INPUT type.\n\n"
            " >> ${getClassName(block)}<FILTER_INPUT> = <$filterInputB> \n"
            " >> ${getClassName(dataFilter)}<FILTER_INPUT> = <$filterInputBF>");
      }
      // -----------------
      const Type filterCriteriaType = FilterCriteria;
      final String filterCriteriaBase = filterCriteriaType.toString();
      final String filterCriteriaBF =
          dataFilter.getFilterCriteriaTypeAsString();
      final String filterCriteriaB = block.getFilterCriteriaTypeAsString();
      //
      if (filterCriteriaBF == filterCriteriaBase) {
        throw ___registerError(
            "You need to create your own class that extends from '$filterCriteriaBase' "
            "as FILTER_CRITERIA for '${getClassName(dataFilter)}'\n\n"
            " >> Currently, ${getClassName(dataFilter)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      if (filterCriteriaBF != filterCriteriaB) {
        throw ___registerError(
            "The Block and its Data-Filter must have the same FILTER_CRITERIA type. \n"
            " >> ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
            " >> ${getClassName(dataFilter)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      dataFilter._blocks.add(block);
      block._registeredOrDefaultDataFilter = dataFilter;
    } else {
      DataFilter defaultDataFilter = _DefaultDataFilter(
        name: "${block.name}-@-default-block-data-filter",
        shelf: this,
      );
      defaultDataFilter._blocks.add(block);
      block._registeredOrDefaultDataFilter = defaultDataFilter;
      //
      _allDataFilters.add(defaultDataFilter);
      //
      const Type emptyFilterCriteriaType = EmptyFilterCriteria;
      final String filterCriteriaEmpty = emptyFilterCriteriaType.toString();
      final String filterCriteriaB = block.getFilterCriteriaTypeAsString();
      //
      if (filterCriteriaB != filterCriteriaEmpty) {
        throw ___registerError(
            "Filter-Criteria of '${getClassName(block)}' block must be '$filterCriteriaEmpty' "
            "because this block does not have a DATA_FILTER.\n\n"
            " >> Currently, ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB>");
      }
    }
    //
    Type extraInputB = ExtraInput;
    String extraInputTypeB = extraInputB.toString();
    String extraInputTypeStr = block.getExtraInputTypeAsString();

    if (extraInputTypeStr == extraInputTypeB) {
      throw ___registerError(
          "You need to create your own class that extends the '$extraInputTypeB' class \n"
          "or use the 'EmptyExtraInput' class to use in the '${getClassName(block)}' declaration \n\n"
          " >> Currently, ${getClassName(block)}<EXTRA_INPUT> = <$extraInputTypeStr>");
    }
    //
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  List<Block> get blocks {
    List<Block> ret = [];
    for (Block rootBlock in __rootBlocks) {
      ret.add(rootBlock);
      ret.addAll(rootBlock.descendantBlocks);
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  ShelfStructure registerStructure();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showMessageDialog({
    required String message,
    String? details,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await dialogs.showMessageDialog(
      context: context,
      message: message,
      details: details,
    );
  }

  Future<void> showShelfStructureDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showStorageDialog(context: context, shelf: this);
  }

  Future<void> showActiveUiComponentsDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showActiveUiComponentsDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Scalar? findScalar(String scalarName) {
    return __scalarMap[scalarName];
  }

  Block? findBlock(String blockName) {
    return __blockMap[blockName];
  }

  DataFilter? findDataFilter(String dataFilterName) {
    return _shelfStruct.dataFilters[dataFilterName];
  }

  List<String> get filterNames => [..._shelfStruct.dataFilters.keys];

  // ***************************************************************************
  // ******** UI COMPONENTS ****************************************************
  // ***************************************************************************

  void __findMountedWidgetStates({
    required List<Block> blocks,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
    required bool withPagination,
    required Map<_WidgetState, bool> founds,
  }) {
    for (Block block in blocks) {
      Map<_WidgetState, bool> m = block._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        activeOnly: activeOnly,
        blocks: block.childBlocks,
        founds: founds,
      );
    }
  }

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_WidgetState, bool> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      activeOnly: activeOnly,
      blocks: __rootBlocks,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents() {
    try {
      print("|----> ${getClassName(this)}.updateAllUIComponents()");
      __updateShelfWidgets();
      //
      for (Scalar scalar in __scalars) {
        scalar.updateAllUIComponents();
      }
      //
      for (Block block in __rootBlocks) {
        __updateBlockAllUiComponentCascade(block);
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }

  void __updateBlockAllUiComponentCascade(Block block) {
    block.updateAllUIComponents();
    //
    for (Block childBlock in block._childBlocks) {
      __updateBlockAllUiComponentCascade(childBlock);
    }
  }

  void __updateShelfWidgets() {
    for (_WidgetState state in _shelfWidgetStateListeners.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _addWidgetStateListener({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _shelfWidgetStateListeners[widgetState] = isShowing;
  }

  void _removeWidgetStateListener({required State widgetState}) {
    _shelfWidgetStateListeners.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<void> _startNewLazyQueryTransactionIfNeed() async {
    if (_queryLocked) {
      await Future.doWhile(
        () => Future.delayed(const Duration(milliseconds: 5))
            .then((_) => _queryLocked),
      );
    }

    if (__transactionId == __lastTransactionNumber) {
      __transactionId++;
      __lazyBlocksToQuery.clear();
      //
      Timer(
        const Duration(milliseconds: 0), // 200
        __queryLazyList,
      );
    }
  }

  Future<void> __queryLazyList() async {
    _queryLocked = true;
    //
    final List<_ScalarOrBlockOrFormWrapper> lazyBlockOrForms =
        __findTopLazyScalarOrBlockOrForms();
    //
    if (lazyBlockOrForms.isEmpty) {
      __lastTransactionNumber = __transactionId;
      _queryLocked = false;
      return;
    } else {
      print("@@@@@@@@@@@@ Query Lazy List: ID: $__transactionId");
      print("@@@@@@@@@@@@ Query Lazy List: Count: ${lazyBlockOrForms.length}");
      //
      __lastTransactionNumber = __transactionId;

      await _queryLazyScalarOrBlockOrForms(
        queryType: QueryType.forceQuery,
        scalarOrBlockOrFormWrappers: lazyBlockOrForms,
      );
      _queryLocked = false;
    }
  }

  Future<bool> _queryLazyScalarOrBlockOrForms({
    required QueryType queryType,
    required List<_ScalarOrBlockOrFormWrapper> scalarOrBlockOrFormWrappers,
  }) async {
    if (scalarOrBlockOrFormWrappers.isEmpty) {
      return true;
    }
    final List<_ScalarOpt> scalarOpts = [];
    final List<_BlockOpt> blockOpts = [];
    final List<_BlockFormOpt> blockFormOpts = [];
    //
    for (_ScalarOrBlockOrFormWrapper wrapper in scalarOrBlockOrFormWrappers) {
      if (wrapper.scalar != null) {
        scalarOpts.add(
          _ScalarOpt(scalar: wrapper.scalar!),
        );
      } else if (wrapper.block != null) {
        blockOpts.add(
          _BlockOpt(
            block: wrapper.block!,
            queryType: null,
            pageable: null,
            listBehavior: null,
            suggestedSelection: null,
            postQueryBehavior: null,
          ),
        );
      } else if (wrapper.blockForm != null) {
        blockFormOpts.add(
          _BlockFormOpt(blockForm: wrapper.blockForm!),
        );
      }
    }
    //
    print("@@@@@@@@@@@@ Query Lazy List: scalarOpts: $scalarOpts");
    print("@@@@@@@@@@@@ Query Lazy List: blockOpts: $blockOpts");
    print("@@@@@@@@@@@@ Query Lazy List: blockFormOpts: $blockFormOpts");
    //
    return await _queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: null,
      forceQueryScalarOpts: scalarOpts,
      forceQueryBlockOpts: blockOpts,
      forceQueryBlockFormOpts: blockFormOpts,
    );
  }

  // ***************************************************************************
  //
  //
  //
  // ***************************************************************************

  void __findLazyScalars(List<_ScalarOrBlockOrFormWrapper> founds) {
    for (Scalar scalar in __scalars) {
      if (scalar.hasActiveUiComponent() &&
          scalar.data.dataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.scalar(scalar));
      }
    }
  }

  void __findTopLazyBlocksCascade(
      List<Block> blocks, List<_ScalarOrBlockOrFormWrapper> founds) {
    for (Block block in blocks) {
      // _hasActiveWidgetAndNeedToQuery()
      if (block.hasActiveBlockFragmentWidget(alsoCheckChildren: true) &&
          block.dataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.block(block));
      } else if (block.blockForm != null &&
          block.blockForm!.hasActiveFormWidget() &&
          block.blockForm!.dataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.blockForm(block.blockForm!));
      } else {
        __findTopLazyBlocksCascade(block._childBlocks, founds);
      }
    }
  }

  List<_ScalarOrBlockOrFormWrapper> __findTopLazyScalarOrBlockOrForms() {
    final List<_ScalarOrBlockOrFormWrapper> founds = [];
    __findLazyScalars(founds);
    __findTopLazyBlocksCascade(__rootBlocks, founds);
    return founds;
  }

  // ***************************************************************************
  // ********** BACKUP & RESTORE & APPLY ***************************************
  // ***************************************************************************

  void _backupAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._backup();
    }
    //
    for (Scalar scalar in __scalars) {
      scalar._backup();
    }
    //
    for (Block rootBlock in __rootBlocks) {
      rootBlock._backupAllFromRoot();
    }
  }

  void _restoreAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._restore();
    }
    //
    for (Scalar scalar in scalars) {
      scalar._restore();
    }
    for (Block block in __rootBlocks) {
      block._restoreAllFromRoot();
    }
    //
    updateAllUIComponents();
  }

  void _applyNewStateAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._applyNewState();
    }
    //
    for (Scalar scalar in scalars) {
      scalar._applyNewState();
    }
    for (Block block in __rootBlocks) {
      block._applyNewStateAllFromRoot();
    }
    //
    updateAllUIComponents();
  }

  // ***************************************************************************
  // ********** QUERY **********************************************************
  // ***************************************************************************

  ///
  /// VERY IMPORTANT METHOD:
  ///
  Future<bool> _queryAllWithOverlayAndRestorable({
    required _DataFilterOpt? forceDataFilterOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_BlockFormOpt> forceQueryBlockFormOpts,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _queryAllWithRestorable(
          forceDataFilterOpt: forceDataFilterOpt,
          forceQueryScalarOpts: forceQueryScalarOpts,
          forceQueryBlockOpts: forceQueryBlockOpts,
          forceQueryBlockFormOpts: forceQueryBlockFormOpts,
        );
      },
    );
  }

  ///
  /// VERY IMPORTANT METHOD:
  ///
  Future<bool> _queryAllWithRestorable({
    required _DataFilterOpt? forceDataFilterOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_BlockFormOpt> forceQueryBlockFormOpts,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: this,
      forceDataFilterOpt: forceDataFilterOpt,
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryBlockFormOpts: forceQueryBlockFormOpts,
    );
    //
    xShelf.printMe();
    //
    try {
      _backupAll();
      //
      for (_XScalar xScalar in xShelf.allXScalars) {
        if (!xScalar.needQuery) {
          continue;
        }
        final _XDataFilter xDataFilter = xScalar.xDataFilter;
        final DataFilter dataFilter = xDataFilter.dataFilter;
        final Scalar scalar = xScalar.scalar;
        //
        final FilterCriteria filterCriteria;
        if (!xDataFilter.queried) {
          // May throw _TransactionError:
          _FilterCriteriaWrapper result = await dataFilter.__prepareData(
            filterInput: xDataFilter.filterInput,
          );
          filterCriteria = result.filterCriteria;
          dataFilter._filterCriteria = filterCriteria;
          xDataFilter.queried = true;
        } else {
          filterCriteria = dataFilter._filterCriteria!;
        }
        //
        bool success = await scalar.__queryThis(
          filterCriteria: filterCriteria,
        );
        if (!success) {
          throw _TransactionError();
        }
      }
      //
      for (_XBlock xBlock in xShelf.allRootXBlocks) {
        bool success = await xBlock.block.__queryThisAndChildren(
          thisXBlock: xBlock,
        );
        //
        if (!success) {
          throw _TransactionError();
        }
      }
      //
      for (_XBlockForm xBlockForm in xShelf.allXBlockForms) {
        if (!xBlockForm.needQuery) {
          continue;
        }
        Object? currentItemDetail =
            xBlockForm.blockForm.block.data.currentItemDetail;

        // TODO: Co can cai nay khong?
        // xBlockForm.blockForm.data._setCurrentItem(
        //   refreshedItemDetail: currentItemDetail,
        //   formMode: FormMode.edit,
        //   dataState: DataState.pending,
        // );

        bool success = await xBlockForm.blockForm._prepareForm(
          extraInput: xBlockForm.extraInput,
          refreshedItem: currentItemDetail,
          isNew: currentItemDetail == null, // TODO: Can kiem tra lai.
          forceForm: true,
        );
        //
        if (!success) {
          throw _TransactionError();
        }
      }
      //
      _applyNewStateAll();
      return true;
    } catch (e, stackTrace) {
      _restoreAll();
      //
      // If _TransactionError, no need to show SnackBar any more..
      //
      if (e is _TransactionError) {
        return false;
      } else {
        _handleError(
          shelf: this,
          methodName: "_queryAllWithRestorable",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
      }
      return false;
    }
  }
}
