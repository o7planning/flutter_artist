part of '../core.dart';

abstract class Shelf extends _Core {
  @override
  Shelf get shelf => this;

  late final ShelfConfig config;

  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All filterModels including the default filterModel.
  final List<FilterModel> _allFilterModels = [];

  List<String> get filterNames => [..._shelfStruct.filterModels.keys];

  // All formModels.
  final List<FormModel> _allFormModels = [];

  final Map<String, Activity> __activityMap = {};

  final List<Activity> __activities = [];

  List<Activity> get activities => [...__activities];

  final Map<String, Scalar> __scalarMap = {};

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => [..._scalars];

  final Map<String, Block> __blockMap = {};

  final List<Block> _rootBlocks = [];

  bool _isStructError = false;

  String? _structError;

  bool get isStructError => _isStructError;

  String? get structError => _structError;

  List<Block> get rootBlocks => [..._rootBlocks];

  int __lastLazyLoadId = 0;

  int __lazyLoadId = 0;

  final List<Block> __lazyBlocksToQuery = [];

  bool __lazyLoadLocked = false;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  late final _ShelfUIComponents ui = _ShelfUIComponents(shelf: this);

  // ***************************************************************************
  // ***************************************************************************

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
    return _createFatalAppError(message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __onInit() {
    _shelfStruct = registerStructure();
    config = _shelfStruct._config;

    for (String filterModelName in _shelfStruct.filterModels.keys) {
      FilterModel filterModel = _shelfStruct.filterModels[filterModelName]!;
      filterModel.name = filterModelName;
      filterModel.shelf = this;
      //
      _allFilterModels.add(filterModel);
    }
    //
    // Activity:
    //
    final List<Activity> activities = _shelfStruct.activities;
    for (Activity activity in activities) {
      if (__activityMap.containsKey(activity.name)) {
        throw ___registerError(
            "Duplicated Activity '${activity.name}' in '${getClassName(this)}'"
            "\nDouble-check ${getClassName(this)}.registerStructure() method");
      } else {
        __activityMap[activity.name] = activity;
      }
      activity.shelf = this;
    }
    //
    // Scalar:
    //
    final List<Scalar> scalars = _shelfStruct.scalars;
    for (Scalar scalar in scalars) {
      if (__scalarMap.containsKey(scalar.name)) {
        throw ___registerError(
            "Duplicated Scalar '${scalar.name}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      } else {
        __scalarMap[scalar.name] = scalar;
      }
      scalar.shelf = this;
      _scalars.add(scalar);
      //
      if (scalar.registerFilterModelName != null) {
        FilterModel? filterModel =
            _shelfStruct.filterModels[scalar.registerFilterModelName!];
        if (filterModel == null) {
          throw ___registerError(
              "FilterModel not found '${scalar.registerFilterModelName}' in '${getClassName(this)}'\n"
              "Double-check ${getClassName(this)}.registerStructure() method");
        }
        //
        const Type filterInputType = FilterInput;
        final filterInputBase = filterInputType.toString();
        final filterInputBF = filterModel.getFilterInputType().toString();
        final filterInputB = scalar.getFilterInputType().toString();
        //
        if (filterInputBF == filterInputBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterInputBase' class \n"
              "or use the 'EmptyFilterInput' class to use in the '${getClassName(filterModel)}' declaration \n\n"
              " >> Currently, ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
        }
        //
        if (filterInputBF != filterInputB) {
          throw ___registerError(
              "The Scalar and its FilterModel must have the same FILTER_INPUT type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_INPUT> = <$filterInputB> \n"
              " >> ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
        }
        // ----------------
        const Type filterCriteriaType = FilterCriteria;
        final filterCriteriaBase = filterCriteriaType.toString();
        final filterCriteriaBF = filterModel.getFilterCriteriaType().toString();
        final filterCriteriaB = scalar.getFilterCriteriaType().toString();
        //
        if (filterCriteriaBF == filterCriteriaBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterCriteriaBase' class \n"
              "or use the 'EmptyFilterCriteria' class to use in the '${getClassName(filterModel)}' declaration \n\n"
              " >> Currently, ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        if (filterCriteriaBF != filterCriteriaB) {
          throw ___registerError(
              "The Scalar and its Filter-Model must have the same FILTER_CRITERIA type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
              " >> ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        filterModel._scalars.add(scalar);
        scalar._registeredOrDefaultFilterModel = filterModel;
      } else {
        // Default FilterModel.
        FilterModel defaultFilterModel = _DefaultFilterModel(
          name: "${scalar.name}-@-default-scalar-filter-model",
          shelf: this,
        );
        defaultFilterModel._scalars.add(scalar);
        scalar._registeredOrDefaultFilterModel = defaultFilterModel;
        //
        _allFilterModels.add(defaultFilterModel);
        //
        const Type emptyFilterCriteriaType = EmptyFilterCriteria;
        final filterCriteriaEmpty = emptyFilterCriteriaType.toString();
        final filterCriteriaB = scalar.getFilterCriteriaType().toString();
        //
        if (filterCriteriaB != filterCriteriaEmpty) {
          throw ___registerError(
              "FILTER_CRITERIA of '${getClassName(scalar)}' scalar must be '$filterCriteriaEmpty' "
              "because this scalar does not have a FILTER_MODEL. \n\n"
              " >> Currently, ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB>");
        }
      }
    }
    //
    // Block:
    //
    List<Block> rootBlocks = _shelfStruct.blocks;
    for (Block rootBlock in rootBlocks) {
      rootBlock.parent = null;
      _rootBlocks.add(rootBlock);
      __registerBlockCascade(rootBlock);
    }
    //
    for (String blockName in __blockMap.keys) {
      Block blk = __blockMap[blockName]!;
      for (Evt evt in blk.config.reQueryByInternalShelfEvents ?? []) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "SHELF '${getClassName(blk.shelf)} -> BLOCK '${getClassName(blk)}' -> reQueryByInternalShelfEvents -> Configuration Error! \n"
              " --> No Block Name: ${evt.srcName}. \n",
            );
          }
          // BLOCK EVENTs: creation, update, deletion:
          if (evt.evtType == null) {
            eventBlock
                ._internalListeners.blockQueryListenerMap[EvtType.creation]!
                .add(blk);
            eventBlock._internalListeners.blockQueryListenerMap[EvtType.update]!
                .add(blk);
            eventBlock._internalListeners.blockQueryListenerMap[EvtType.update]!
                .add(blk);
          } else {
            eventBlock._internalListeners.blockQueryListenerMap[evt.evtType]!
                .add(blk);
          }
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "SHELF '${getClassName(blk.shelf)} -> BLOCK '${getClassName(blk)}' -> reQueryByInternalShelfEvents -> Configuration Error! \n"
              " --> No Scalar Name: ${evt.srcName}. \n",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalListeners.blockQueryListenerMap[evt.evtType]!
              .add(blk);
        }
      }
      //
      for (Evt evt in blk.config.refreshCurrItemByInternalShelfEvents ?? []) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "SHELF '${getClassName(blk.shelf)} -> BLOCK '${getClassName(blk)}' -> refreshCurrItemByInternalShelfEvents -> Configuration Error! \n"
              " --> No Block Name: ${evt.srcName}. \n",
            );
          }
          // BLOCK EVENTS: creation, update, deletion:
          if (evt.evtType == null) {
            eventBlock._internalListeners
                .blockRefreshCurrListenerMap[EvtType.creation]!
                .add(blk);
            eventBlock
                ._internalListeners.blockRefreshCurrListenerMap[EvtType.update]!
                .add(blk);
            eventBlock
                ._internalListeners.blockRefreshCurrListenerMap[EvtType.update]!
                .add(blk);
          } else {
            eventBlock
                ._internalListeners.blockRefreshCurrListenerMap[evt.evtType]!
                .add(blk);
          }
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "SHELF '${getClassName(blk.shelf)} -> BLOCK '${getClassName(blk)}' -> refreshCurrItemByInternalShelfEvents -> Configuration Error! \n"
              " --> No Scalar Name: ${evt.srcName}. \n",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalListeners.blockQueryListenerMap[evt.evtType]!
              .add(blk);
        }
      }
    }
    //
    for (String scalarName in __scalarMap.keys) {
      Scalar sclr = __scalarMap[scalarName]!;
      for (Evt evt in sclr.config.reQueryByInternalShelfEvents ?? []) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "SHELF '${getClassName(sclr.shelf)} -> SCALAR '${getClassName(sclr)}' -> reQueryByInternalShelfEvents -> Configuration Error! \n"
              " --> No Block Name: ${evt.srcName}. \n",
            );
          }
          // BLOCK EVENT: creation, update, deletion:
          if (evt.evtType == null) {
            eventBlock
                ._internalListeners.scalarQueryListenerMap[EvtType.creation]!
                .add(sclr);
            eventBlock
                ._internalListeners.scalarQueryListenerMap[EvtType.update]!
                .add(sclr);
            eventBlock
                ._internalListeners.scalarQueryListenerMap[EvtType.update]!
                .add(sclr);
          } else {
            eventBlock._internalListeners.scalarQueryListenerMap[evt.evtType]!
                .add(sclr);
          }
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "SHELF '${getClassName(sclr.shelf)} -> SCALAR '${getClassName(sclr)}' -> reQueryByInternalShelfEvents -> Configuration Error! \n"
              " --> No Scalar Name: ${evt.srcName}. \n",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalListeners.scalarQueryListenerMap[evt.evtType]!
              .add(sclr);
        }
      }
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
      if (block.formModel != null) {
        _allFormModels.add(block.formModel!);
      }
    }
    //
    block.shelf = this;
    if (block.registerFilterModelName != null) {
      FilterModel? filterModel =
          _shelfStruct.filterModels[block.registerFilterModelName!];
      if (filterModel == null) {
        throw ___registerError(
            "FilterModel not found '${block.registerFilterModelName}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      }
      //
      //
      const Type filterInputType = FilterInput;
      final filterInputBase = filterInputType.toString();
      final filterInputBF = filterModel.getFilterInputType().toString();
      final filterInputB = block.getFilterInputType().toString();
      //
      if (filterInputBF == filterInputBase) {
        throw ___registerError(
            "You need to create your own class that extends the '$filterInputBase' class \n"
            "or use the 'EmptyFilterInput' class to use in the '${getClassName(filterModel)}' declaration \n\n"
            " >> Currently, ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      //
      if (filterInputBF != filterInputB) {
        throw ___registerError(
            "The Block and its FilterModel must have the same FILTER_INPUT type.\n\n"
            " >> ${getClassName(block)}<FILTER_INPUT> = <$filterInputB> \n"
            " >> ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      // -----------------
      const Type filterCriteriaType = FilterCriteria;
      final filterCriteriaBase = filterCriteriaType.toString();
      final filterCriteriaBF = filterModel.getFilterCriteriaType().toString();
      final String filterCriteriaB = block.getFilterCriteriaType().toString();
      //
      if (filterCriteriaBF == filterCriteriaBase) {
        throw ___registerError(
            "You need to create your own class that extends from '$filterCriteriaBase' "
            "as FILTER_CRITERIA for '${getClassName(filterModel)}'\n\n"
            " >> Currently, ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      if (filterCriteriaBF != filterCriteriaB) {
        throw ___registerError(
            "The Block and its Filter-Model must have the same FILTER_CRITERIA type. \n"
            " >> ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
            " >> ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      filterModel._blocks.add(block);
      block._registeredOrDefaultFilterModel = filterModel;
    } else {
      FilterModel defaultFilterModel = _DefaultFilterModel(
        name: "${block.name}-@-default-block-filter-model",
        shelf: this,
      );
      defaultFilterModel._blocks.add(block);
      block._registeredOrDefaultFilterModel = defaultFilterModel;
      //
      _allFilterModels.add(defaultFilterModel);
      //
      const Type emptyFilterCriteriaType = EmptyFilterCriteria;
      final filterCriteriaEmpty = emptyFilterCriteriaType.toString();
      final filterCriteriaB = block.getFilterCriteriaType().toString();
      //
      if (filterCriteriaB != filterCriteriaEmpty) {
        throw ___registerError(
            "Filter-Criteria of '${getClassName(block)}' block must be '$filterCriteriaEmpty' "
            "because this block does not have a FILTER_MODEL.\n\n"
            " >> Currently, ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB>");
      }
    }
    //
    Type extraFormInputB = ExtraFormInput;
    String extraFormInputTypeB = extraFormInputB.toString();
    String extraFormInputTypeStr = block.getExtraFormInputType().toString();

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
    for (Block rootBlock in _rootBlocks) {
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
    await StorageDialog.showStorageDialog(
      context: context,
      shelf: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showActiveUiComponentsDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await UiComponentsDialog.showActiveUIComponentsDialog(
      context: context,
      shelf: this,
    );
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

  Activity? findActivity(String activityName) {
    return __activityMap[activityName];
  }

  // ***************************************************************************
  // ***************************************************************************

  FilterModel? findFilterModel(String filterModelName) {
    return _shelfStruct.filterModels[filterModelName];
  }

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
    required Map<_RefreshableWidgetState, XState> founds,
  }) {
    for (Block block in blocks) {
      Map<_RefreshableWidgetState, XState> m =
          block.ui._findMountedWidgetStates(
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

  @DebugMethodAnnotation()
  Map<IRefreshableWidgetState, XState> debugFindMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    return _findMountedWidgetStates(
      withBlockFragment: withBlockFragment,
      withPagination: withPagination,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
    );
  }

  Map<_RefreshableWidgetState, XState> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, XState> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
      blocks: _rootBlocks,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<void> _startLoadDataForLazyUIComponentsIfNeed() async {
    if (__lazyLoadLocked) {
      await Future.doWhile(
        () => Future.delayed(const Duration(milliseconds: 1))
            .then((_) => __lazyLoadLocked),
      );
    }

    // New Code:
    // SchedulerBinding binding = SchedulerBinding.instance;
    // bool hasScheduledFrame = binding.hasScheduledFrame;
    // if (hasScheduledFrame) {
    //   await Future.doWhile(() async {
    //     await Future.delayed(Duration.zero);
    //     bool hasScheduledFrame2 = binding.hasScheduledFrame;
    //     return hasScheduledFrame2;
    //   });
    // }

    if (__lazyLoadId == __lastLazyLoadId) {
      __lazyLoadId++;
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
    __lazyLoadLocked = true;
    // Top Lazy (Scalar, Block or FormModel).
    final _LazyObjects lazyObjects = __findLazyObjects();

    print(">>>> lazyObjects: $lazyObjects");
    lazyObjects.printInfo();
    //
    if (lazyObjects.isEmpty) {
      __lastLazyLoadId = __lazyLoadId;
      __lazyLoadLocked = false;
      // IMPORTANT: No Lazy entities, but need to refresh UIComponents:
      ui.updateAllUIComponents();
      return;
    }
    print("@@@@@@@@@@@@ Lazy Load - ID: $__lazyLoadId");
    print("@@@@@@@@@@@@ Lazy Load - Count: ${lazyObjects.count}");
    //
    __lastLazyLoadId = __lazyLoadId;
    //

    final List<_ScalarOpt> scalarOpts = [];
    final List<_BlockOpt> topLazyBlockOpts = [];
    final List<_FormModelOpt> topLazyFormModelOpts = [];
    //
    for (_LazyScalar lazyScalar in lazyObjects.lazyScalars) {
      lazyScalar.scalar._lazyLoadCount++;
      //
      scalarOpts.add(
        _ScalarOpt(scalar: lazyScalar.scalar),
      );
    }
    for (_LazyBlock lazyBlock in lazyObjects.lazyBlocks) {
      lazyBlock.block._lazyLoadCount++;
      //
      topLazyBlockOpts.add(
        _BlockOpt(
          block: lazyBlock.block,
          forceQuery: lazyBlock.forceQuery,
          forceReloadItem: false,
          pageable: null,
          listBehavior: null,
          suggestedSelection: null,
          postQueryBehavior: null,
        ),
      );
    }
    for (_LazyFormModel lazyFormModel in lazyObjects.lazyFormModels) {
      lazyFormModel.formModel._lazyLoadCount++;
      //
      topLazyFormModelOpts.add(
        _FormModelOpt(formModel: lazyFormModel.formModel),
      );
    }
    //
    print("@@@@@@@@@@@@ Query Lazy List: scalarOpts: $scalarOpts");
    print("@@@@@@@@@@@@ Query Lazy List: topLazyBlockOpts: $topLazyBlockOpts");
    print(
        "@@@@@@@@@@@@ Query Lazy List: topLazyFormModelOpts: $topLazyFormModelOpts");
    //
    try {
      //
      // TODO: Handle Error:
      //
      await _queryAll(
        naturalMode: true,
        forceFilterModelOpt: null,
        forceQueryScalarOpts: scalarOpts,
        forceQueryBlockOpts: topLazyBlockOpts,
        forceQueryFormModelOpts: topLazyFormModelOpts,
      );
    } finally {
      __lazyLoadLocked = false;
    }
  }

  // ***************************************************************************
  //
  //
  //
  // ***************************************************************************

  void __findLazyScalars(_LazyObjects founds) {
    for (Scalar scalar in _scalars) {
      if (scalar.ui.hasActiveUIComponent()) {
        if (scalar.queryDataState == DataState.pending ||
            scalar.queryDataState == DataState.error) {
          founds.addLazyScalar(scalar: scalar);
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __findXVisibleLazyBlocksCascade(
    List<Block> blocks,
    _LazyObjects founds,
  ) {
    for (Block block in blocks) {
      bool found = false;
      //
      // TODO: Mới kt các fragment, còn các cái khác thì sao? ItemsView?
      //
      if (block.ui.hasActiveBlockFragmentWidget(alsoCheckChildren: true)) {
        if (block.queryDataState == DataState.pending ||
            block.queryDataState == DataState.error) {
          founds.addLazyBlock(block: block, forceQuery: true);
          found = true;
        } else if (block.queryDataState == DataState.ready) {
          if (block.itemCount > 0 && block.currentItem == null) {
            founds.addLazyBlock(block: block, forceQuery: false);
            found = true;
          }
        }
      }
      //
      if (block.formModel != null &&
          block.formModel!.ui.hasActiveUIComponent()) {
        if (block.formModel!.formDataState == DataState.pending ||
            block.formModel!.formDataState == DataState.error ||
            block.formModel!.formDataState == DataState.none) {
          founds.addLazyFormModel(formModel: block.formModel!);
          found = true;
        }
      }
      //
      __findXVisibleLazyBlocksCascade(block._childBlocks, founds);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  _LazyObjects __findLazyObjects() {
    final _LazyObjects founds = _LazyObjects();
    __findLazyScalars(founds);
    __findXVisibleLazyBlocksCascade(_rootBlocks, founds);
    return founds;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<_XShelf> _queryAll({
    bool naturalMode = false,
    required _FilterModelOpt? forceFilterModelOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) async {
    _XShelf xShelf = _XShelf(
      naturalMode: naturalMode,
      shelf: this,
      forceFilterModelOpt: forceFilterModelOpt,
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryFormModelOpts: forceQueryFormModelOpts,
    );
    //
    await _executeQueryXShelf(xShelf: xShelf);
    return xShelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeQueryXShelf({
    required _XShelf xShelf,
  }) async {
    xShelf.printMe();
    //
    for (_XScalar xScalar in xShelf.allXScalars) {
      if (!xScalar.needQuery) {
        continue;
      }
      //
      // Add to Queue:
      //
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _ScalarQueryTaskUnit(
          xScalar: xScalar,
        ),
      );
    }
    //
    for (_XBlock xBlock in xShelf.allRootXBlocks) {
      //
      // Add to Queue:
      //
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockQueryTaskUnit(
          xBlock: xBlock,
        ),
      );
    }
    //
    // for (_XFormModel xFormModel in xShelf.allXFormModels) {
    //   if (!xFormModel.forceForm) {
    //     continue;
    //   }
    //   //
    //   // Add to Queue:
    //   //
    //   FlutterArtist.taskUnitQueue.addTaskUnit(
    //     _FormModelLoadFormTaskUnit(
    //       xFormModel: xFormModel,
    //     ),
    //   );
    // }
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "${getClassName(this)}($name)";
  }
}
