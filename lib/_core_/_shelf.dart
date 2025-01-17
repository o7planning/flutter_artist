part of '../flutter_artist.dart';

abstract class Shelf {
  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All dataFilters including the default dataFilter.
  final List<DataFilter> _allDataFilters = [];

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

  int __currentTransactionNumber = 0;

  final List<Block> __lazyBlocksToQuery = [];

  bool _queryLocked = false;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  final Map<_WidgetState, bool> _shelfWidgetStateListeners = {};

  Shelf() {
    __onInit();
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
        throw _registerError(
            "Duplicated Scalar '${scalar.name}' in '${getClassName(this)}'");
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
          throw _registerError(
              "DataFilter not found '${scalar.registerDataFilterName}' in '${getClassName(this)}'");
        }
        //
        const Type filterSnapshotType = FilterSnapshot;
        final String filterSnapshotBase = filterSnapshotType.toString();
        final String filterSnapshotBF =
            dataFilter.getFilterSnapshotTypeAsString();
        final String filterSnapshotB = scalar.getFilterSnapshotTypeAsString();
        //
        if (filterSnapshotBF == filterSnapshotBase) {
          throw _registerError(
              "You need to create your own class that extends from '$filterSnapshotBase' "
              "as Filter-Snapshot for '${getClassName(dataFilter)}'\n"
              " >> Currently, Filter-Snapshot of '${getClassName(dataFilter)}'  Data-Filter is '$filterSnapshotBF'");
        }
        //
        if (filterSnapshotBF != filterSnapshotB) {
          throw _registerError(
              "Scalar and  Data-Filter must have the same Filter-Snapshot type.\n"
              " >> Filter-Snapshot of '${getClassName(scalar)}' Scalar is '$filterSnapshotB'\n"
              " >> Filter-Snapshot of '${getClassName(dataFilter)}'  Data-Filter is '$filterSnapshotBF'");
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
        const Type emptyFilterSnapshotType = EmptyFilterSnapshot;
        final String filterSnapshotEmpty = emptyFilterSnapshotType.toString();
        final String filterSnapshotB = scalar.getFilterSnapshotTypeAsString();
        //
        if (filterSnapshotB != filterSnapshotEmpty) {
          throw _registerError(
              "Filter-Snapshot of '${getClassName(scalar)}' scalar must be '$filterSnapshotEmpty' "
              "because this scalar does not have a  Data-Filter.\n"
              " >> Currently, its Filter-Snapshot is '$filterSnapshotB'");
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
      throw _registerError(
          "Duplicated block '${block.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.registerStructure() method");
    } else {
      __blockMap[block.name] = block;
    }
    //
    block.shelf = this;
    if (block.registerDataFilterName != null) {
      DataFilter? dataFilter =
          _shelfStruct.dataFilters[block.registerDataFilterName!];
      if (dataFilter == null) {
        throw _registerError(
            "DataFilter not found '${block.registerDataFilterName}' in '${getClassName(this)}'");
      }
      const Type filterSnapshotType = FilterSnapshot;
      final String filterSnapshotBase = filterSnapshotType.toString();
      final String filterSnapshotBF =
          dataFilter.getFilterSnapshotTypeAsString();
      final String filterSnapshotB = block.getFilterSnapshotTypeAsString();
      //
      if (filterSnapshotBF == filterSnapshotBase) {
        throw _registerError(
            "You need to create your own class that extends from '$filterSnapshotBase' "
            "as Filter-Snapshot for '${getClassName(dataFilter)}'\n"
            " >> Currently, Filter-Snapshot of '${getClassName(dataFilter)}'  Data-Filter is '$filterSnapshotBF'");
      }
      //
      if (filterSnapshotBF != filterSnapshotB) {
        throw _registerError(
            "Block and  Data-Filter must have the same Filter-Snapshot type.\n"
            " >> Filter-Snapshot of '${getClassName(block)}' Block is '$filterSnapshotB'\n"
            " >> Filter-Snapshot of '${getClassName(dataFilter)}'  Data-Filter is '$filterSnapshotBF'");
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
      const Type emptyFilterSnapshotType = EmptyFilterSnapshot;
      final String filterSnapshotEmpty = emptyFilterSnapshotType.toString();
      final String filterSnapshotB = block.getFilterSnapshotTypeAsString();
      //
      if (filterSnapshotB != filterSnapshotEmpty) {
        throw _registerError(
            "Filter-Snapshot of '${getClassName(block)}' block must be '$filterSnapshotEmpty' "
            "because this block does not have a  Data-Filter.\n"
            " >> Currently, its Filter-Snapshot is '$filterSnapshotB'");
      }
    }
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

  Future<void> showMessageDialog(
      {required String message, String? details}) async {
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

  void __updateAllWidgetsCascade(Block block) {
    block.updateFragmentWidgets();
    block.updatePaginationWidgets();
    block.updateControlBarWidgets();
    block.blockForm?.updateFormWidgets();
    block._registeredOrDefaultDataFilter.updateWidgets();
    //
    for (Block childBlock in block._childBlocks) {
      __updateAllWidgetsCascade(childBlock);
    }
  }

  void updateAllWidgets() {
    for (_WidgetState state in _shelfWidgetStateListeners.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
    //
    for (Scalar scalar in __scalars) {
      scalar.updateControlBarWidgets();
      scalar.updateFragmentWidgets();
    }
    for (Block block in __rootBlocks) {
      __updateAllWidgetsCascade(block);
    }
  }

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

    if (__currentTransactionNumber == __lastTransactionNumber) {
      __currentTransactionNumber++;
      __lazyBlocksToQuery.clear();

      print(
          "\n\n@@@@@@@>>>>>>>>>>>>>>> query - ID: $__currentTransactionNumber");

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
      __lastTransactionNumber = __currentTransactionNumber;
      _queryLocked = false;
      return;
    } else {
      print("@@@@@@@@@@@@ __queryLazyList: ID: $__currentTransactionNumber");
      __lastTransactionNumber = __currentTransactionNumber;

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
        scalarOpts.add(_ScalarOpt(scalar: wrapper.scalar!));
      } else if (wrapper.block != null) {
        blockOpts.add(_BlockOpt(
          block: wrapper.block!,
          pageable: null,
          listBehavior: null,
          suggestedSelection: null,
          postQueryBehavior: null,
        ));
      } else if (wrapper.blockForm != null) {
        blockFormOpts.add(_BlockFormOpt(blockForm: wrapper.blockForm!));
      }
    }
    //
    return await _queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: null,
      forceQueryScalarOpts: scalarOpts,
      forceQueryBlockOpts: blockOpts,
      forceQueryBlockFormOpts: blockFormOpts,
    );
    //
    //
    //
    bool needToUpdate = false;
    bool success = false;
    try {
      print(
          "@@@@@@@@@@@@@@@@@@@@@@@@@@@ >>>>>>>>>>> : $scalarOrBlockOrFormWrappers");

      for (_ScalarOrBlockOrFormWrapper wrapper in scalarOrBlockOrFormWrappers) {
        needToUpdate = true;
        // QUERY SCALAR:
        if (wrapper.scalar != null) {
          FlutterArtist.codeFlowLogger._addInfo(
            isLibCode: true,
            ownerClassInstance: this,
            info: "Querying lazy Scalar: ${getClassName(wrapper.scalar)}",
          );
          //
          // TODO: Mở rào này ra ???????????????????????????????????????????????????????????????????????????
          // TODO: ???????????????????????????????????????????????????????????????????????????
          // success = await wrapper.scalar!._queryWithOverlayAndRestorable();
          // if (!success) {
          //   break;
          // }
        }
        // QUERY BLOCK:
        else if (wrapper.block != null) {
          FlutterArtist.codeFlowLogger._addInfo(
            isLibCode: true,
            ownerClassInstance: this,
            info: "Querying lazy block: ${getClassName(wrapper.block)}",
          );
          //
          success = await wrapper.block!._queryWithOverlayAndRestorable(
            queryType: queryType,
            listBehavior: ListBehavior.replace,
            suggestedFilterSnapshot: null,
            postQueryBehavior: PostQueryBehavior.selectAvailableItem,
            suggestedSelection: null,
            pageable: null, // TODO: Reset?
          );
          if (!success) {
            break;
          }
        }
        // QUERY BLOCK-FORM:
        else if (wrapper.blockForm != null) {
          FlutterArtist.codeFlowLogger._addInfo(
            isLibCode: true,
            ownerClassInstance: this,
            info:
                "Querying lazy block form: ${getClassName(wrapper.blockForm)}",
          );
          //
          Block block = wrapper.blockForm!.block;
          Object? currentItem = block.data.currentItemDetail;
          if (currentItem != null) {
            success = await block._prepareToShowOrEditWithOverlayAndRestorable(
              item: currentItem,
              justQueried: false,
              suggestedSelection: null,
              forceForm: true,
            );
            if (!success) {
              break;
            }
          }
        }
      }
    } catch (e) {
      success = false;
    }
    if (needToUpdate) {
      updateAllWidgets();
    }
    return success;
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

  Future<bool> _queryScalars({
    required List<Scalar> scalars,
  }) async {
    for (Scalar scalar in scalars) {
      bool success = await scalar.query();
      if (!success) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _queryBlocks({
    required QueryType queryType,
    required List<Block> blocks,
  }) async {
    List<_ScalarOrBlockOrFormWrapper> blockOrForms =
        blocks.map((b) => _ScalarOrBlockOrFormWrapper.block(b)).toList();
    //
    return await _queryLazyScalarOrBlockOrForms(
      queryType: queryType,
      scalarOrBlockOrFormWrappers: blockOrForms,
    );
  }

  // ***************************************************************************
  // ********** BACKUP & RESTORE & APPLY ***************************************
  // ***************************************************************************

  void __backupAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._backup();
    }
    //
    for (Scalar scalar in __scalars) {
      scalar._backup();
    }
    //
    for (Block rootBlock in __rootBlocks) {
      rootBlock._backupAll();
    }
    // TODO: Backup BlockForm ????????????????????????????????????????????????????
    //
    updateAllWidgets();
  }

  void __restoreAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._restore();
    }
    //
    for (Scalar scalar in scalars) {
      scalar._restore();
    }
    for (Block block in blocks) {
      block._restoreAll();
    }
    // TODO: Restore BlockForm ????????????????????????????????????????????????????
    //
    updateAllWidgets();
  }

  void __applyNewStateAll() {
    for (DataFilter dataFilter in _allDataFilters) {
      dataFilter._applyNewState();
    }
    //
    for (Scalar scalar in scalars) {
      scalar._applyNewStateAll();
    }
    for (Block block in blocks) {
      block._applyNewStateAll();
    }
    //
    updateAllWidgets();
  }

  // ***************************************************************************
  // ********** QUERY **********************************************************
  // ***************************************************************************

  Future<bool> _queryAllWithOverlayAndRestorable({
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
    try {
      __backupAll();
      //
      for (_XScalar xScalar in xShelf.allXScalars) {
        if (!xScalar.needQuery) {
          continue;
        }
      }
      //
      __applyNewStateAll();
      return true;
    } catch (e) {
      __restoreAll();
      //
      if (e is _QueryError) {
        // Do not showSnackBar any more...
      }

      return false;
    }
  }
}
