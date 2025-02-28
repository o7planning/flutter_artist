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

  final Map<_RefreshableWidgetState, bool> _shelfWidgetStates = {};

  Shelf() {
    __onInit();
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

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
    Type extraFormInputB = ExtraFormInput;
    String extraFormInputTypeB = extraFormInputB.toString();
    String extraFormInputTypeStr = block.getExtraFormInputTypeAsString();

    if (extraFormInputTypeStr == extraFormInputTypeB) {
      throw ___registerError(
          "You need to create your own class that extends the '$extraFormInputTypeB' class \n"
          "or use the 'EmptyExtraFormInput' class to use in the '${getClassName(block)}' declaration \n\n"
          " >> Currently, ${getClassName(block)}<EXTRA_FORM_INPUT> = <$extraFormInputTypeStr>");
    }
    //
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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

  Future<void> showShelfStructureDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showStorageDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showActiveUiComponentsDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showActiveUIComponentsDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Scalar? findScalar(String scalarName) {
    return __scalarMap[scalarName];
  }

  // ***************************************************************************
  // ***************************************************************************

  Block? findBlock(String blockName) {
    return __blockMap[blockName];
  }

  // ***************************************************************************
  // ***************************************************************************

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
    required bool withControl,
    required bool activeOnly,
    required bool withPagination,
    required Map<_RefreshableWidgetState, bool> founds,
  }) {
    for (Block block in blocks) {
      Map<_RefreshableWidgetState, bool> m = block._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
        activeOnly: activeOnly,
        blocks: block.childBlocks,
        founds: founds,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, bool> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, bool> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
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
      for (DataFilter dataFilter in _allDataFilters) {
        dataFilter.updateAllUIComponents();
      }
      //
      for (Scalar scalar in __scalars) {
        scalar.updateAllUIComponents(withoutFilters: true);
      }
      //
      for (Block block in __rootBlocks) {
        __updateAllBlockUIComponentsCascade(block, withoutFilters: true);
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateAllBlockUIComponentsCascade(
    Block block, {
    required bool withoutFilters,
  }) {
    block.updateAllUIComponents(withoutFilters: withoutFilters);
    //
    for (Block childBlock in block._childBlocks) {
      __updateAllBlockUIComponentsCascade(
        childBlock,
        withoutFilters: withoutFilters,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateShelfWidgets() {
    for (_RefreshableWidgetState state in _shelfWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _addShelfWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _shelfWidgetStates[widgetState] = isShowing;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    _shelfWidgetStates.remove(widgetState);
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
      Future.delayed(
        const Duration(milliseconds: 0),
        () {
          __queryLazyList();
        },
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _queryLazyScalarOrBlockOrForms({
    required QueryType queryType,
    required List<_ScalarOrBlockOrFormWrapper> scalarOrBlockOrFormWrappers,
  }) async {
    if (scalarOrBlockOrFormWrappers.isEmpty) {
      return true;
    }
    //
    final List<_ScalarOpt> scalarOpts = [];
    final List<_BlockOpt> blockOpts = [];
    final List<_BlockFormOpt> blockFormOpts = [];
    //
    for (_ScalarOrBlockOrFormWrapper wrapper in scalarOrBlockOrFormWrappers) {
      if (wrapper.scalar != null) {
        wrapper.scalar!._lazyLoadCount++;
        //
        scalarOpts.add(
          _ScalarOpt(scalar: wrapper.scalar!),
        );
      } else if (wrapper.block != null) {
        wrapper.block!._lazyLoadCount++;
        //
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
        wrapper.blockForm!._lazyLoadCount++;
        //
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
      if (scalar.hasActiveUIComponent() &&
          scalar.data.dataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.scalar(scalar));
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __findTopLazyBlocksCascade(
      List<Block> blocks, List<_ScalarOrBlockOrFormWrapper> founds) {
    for (Block block in blocks) {
      // _hasActiveWidgetAndNeedToQuery()
      if (block.hasActiveBlockFragmentWidget(alsoCheckChildren: true) &&
          block.queryDataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.block(block));
      } else if (block.blockForm != null &&
          block.blockForm!.hasActiveUIComponent() &&
          block.blockForm!.dataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.blockForm(block.blockForm!));
      } else {
        __findTopLazyBlocksCascade(block._childBlocks, founds);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_ScalarOrBlockOrFormWrapper> __findTopLazyScalarOrBlockOrForms() {
    final List<_ScalarOrBlockOrFormWrapper> founds = [];
    __findLazyScalars(founds);
    __findTopLazyBlocksCascade(__rootBlocks, founds);
    return founds;
  }

  // ***************************************************************************
  // ********** ACTIVE/MOUNTED COMPONENT ***************************************
  // ***************************************************************************

  bool _hasMountedScalarUIComponent() {
    for (Scalar scalar in scalars) {
      if (scalar.hasMountedUIComponent()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasMountedBlockUIComponentCascade(List<Block> blocks) {
    for (Block block in blocks) {
      if (block.hasMountedUIComponent()) {
        return true;
      }
      bool hasMounted = _hasMountedBlockUIComponentCascade(block._childBlocks);
      if (hasMounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    bool hasMounted = _shelfWidgetStates.isNotEmpty;
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedBlockUIComponentCascade(__rootBlocks);
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedScalarUIComponent();
    if (hasMounted) {
      return true;
    }
    return false;
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

  // ***************************************************************************
  // ***************************************************************************

  String _toString({
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_BlockFormOpt> forceQueryBlockFormOpts,
  }) {
    String info = "";
    if (forceQueryScalarOpts.isNotEmpty) {
      String s = forceQueryScalarOpts
          .map((opt) => getClassName(opt.scalar))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryBlockOpts.isNotEmpty) {
      String s =
          forceQueryBlockOpts.map((opt) => getClassName(opt.block)).join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryBlockFormOpts.isNotEmpty) {
      String s = forceQueryBlockFormOpts
          .map((opt) => getClassName(opt.blockForm))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    return info;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// VERY IMPORTANT METHOD:
  ///
  Future<bool> _queryAllWithRestorable({
    required _DataFilterOpt? forceDataFilterOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_BlockFormOpt> forceQueryBlockFormOpts,
  }) async {
    String info = _toString(
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryBlockFormOpts: forceQueryBlockFormOpts,
    );
    FlutterArtist.codeFlowLogger._addInfo(
      ownerClassInstance: this,
      info: 'Execute Lazy Query: $info',
      isLibCode: true,
    );
    //
    // try {
    //   _backupAll();
    //   //
    //   bool success = await _queryAll(
    //     forceDataFilterOpt: forceDataFilterOpt,
    //     forceQueryScalarOpts: forceQueryScalarOpts,
    //     forceQueryBlockOpts: forceQueryBlockOpts,
    //     forceQueryBlockFormOpts: forceQueryBlockFormOpts,
    //   );
    //   if (!success) {
    //     _restoreAll();
    //     return false;
    //   } else {
    //     _applyNewStateAll();
    //     return true;
    //   }
    // } catch (e, stackTrace) {
    //   _restoreAll();
    //   //
    //   _handleError(
    //     shelf: this,
    //     methodName: "_queryAllWithRestorable",
    //     error: e,
    //     stackTrace: stackTrace,
    //     showSnackBar: true,
    //   );
    //   return false;
    // }
    bool success = await _queryAll(
      forceDataFilterOpt: forceDataFilterOpt,
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryBlockFormOpts: forceQueryBlockFormOpts,
    );
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _queryAll({
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
    return await _executeQueryXShelf(xShelf: xShelf);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _executeQueryXShelf({
    required _XShelf xShelf,
  }) async {
    try {
      for (_XScalar xScalar in xShelf.allXScalars) {
        if (!xScalar.needQuery) {
          continue;
        }
        // final _XDataFilter xDataFilter = xScalar.xDataFilter;
        // final DataFilter dataFilter = xDataFilter.dataFilter;
        // final Scalar scalar = xScalar.scalar;
        // //
        // final FilterCriteria filterCriteria;
        // if (!xDataFilter.queried) {
        //   //
        //   FilterCriteria? newCriteria = await dataFilter._prepareData(
        //     filterInput: xDataFilter.filterInput,
        //   );
        //   if (newCriteria == null) {
        //     return false;
        //   }
        //   filterCriteria = newCriteria;
        //   xDataFilter.queried = true;
        // } else {
        //   filterCriteria = dataFilter._filterCriteria!;
        // }
        // //
        // bool success = await scalar.__queryThis(
        //   filterCriteria: filterCriteria,
        // );
        // if (!success) {
        //   return false;
        // }

        //
        // Add to Queue:
        //
        _taskUnitQueue.addTaskUnit(
          _ScalarTaskUnit(
            xScalar: xScalar,
            taskUnitName: ScalarTaskUnitName.query,
          ),
        );
      }
      //
      for (_XBlock xBlock in xShelf.allRootXBlocks) {
        //
        // Add to Queue:
        //
        _taskUnitQueue.addTaskUnit(
          _BlockQueryTaskUnit(
            xBlock: xBlock,
          ),
        );
      }
      //
      for (_XBlockForm xBlockForm in xShelf.allXBlockForms) {
        if (!xBlockForm.needQuery) {
          continue;
        }
        //
        // Add to Queue:
        //
        _taskUnitQueue.addTaskUnit(
          _BlockFormLoadFormTaskUnit(
            xBlockForm: xBlockForm,
          ),
        );
      }
      //
      await _executeTaskUnitQueue();
      //
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: this,
        methodName: "_queryAll",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeTaskUnitQueue() async {
    while (_taskUnitQueue.hasNext()) {
      _TaskUnit taskUnit = _taskUnitQueue.getNextTaskUnit()!;
      // Block Query:
      if (taskUnit is _BlockQueryTaskUnit) {
        _XBlock xBlock = taskUnit.xBlock;
        await xBlock.block._unitQuery(thisXBlock: xBlock);
      }
      // Block Select Item as Current:
      else if (taskUnit is _BlockSelectAsCurrentTaskUnit) {
        _XBlock xBlock = taskUnit.xBlock;
        await xBlock.block._unitPrepareToShow(thisXBlock: xBlock);
      }
      // Block Delete Item:
      else if (taskUnit is _BlockDeleteItemTaskUnit) {
        _XBlock xBlock = taskUnit.xBlock;
        await xBlock.block._executeDeleteItemTaskUnit(taskUnit);
      }
      // Block QuickCreateItem:
      else if (taskUnit is _BlockQuickCreateItemTaskUnit) {
        _XBlock xBlock = taskUnit.xBlock;
        await xBlock.block._executeQuickCreateItemTaskUnit(taskUnit);
      }
      // Block QuickUpdateItem:
      else if (taskUnit is _BlockQuickUpdateItemTaskUnit) {
        _XBlock xBlock = taskUnit.xBlock;
        await xBlock.block._executeQuickUpdateItemTaskUnit(taskUnit);
      }
      // BlockForm LoadForm:
      else if (taskUnit is _BlockFormLoadFormTaskUnit) {
        _XBlockForm xBlockForm = taskUnit.xBlockForm;
        await xBlockForm.blockForm._unitLoadForm(
          thisXBlockForm: xBlockForm,
        );
      }
      // BlockForm Save:
      else if (taskUnit is _SaveFormSaveTaskUnit) {
        _XBlockForm xBlockForm = taskUnit.xBlockForm;
        await xBlockForm.blockForm._unitSaveForm(
          thisXBlockForm: xBlockForm,
        );
      }
      // Scalar:
      else if (taskUnit is _ScalarTaskUnit) {
        _XScalar xScalar = taskUnit.xScalar;
        await xScalar.scalar._executeTaskUnit(taskUnit);
      }
    }
    updateAllUIComponents();
  }
}
