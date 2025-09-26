part of '../core.dart';

abstract class Shelf extends _Core {
  Shelf get shelf => this;

  ReactionType __reactionTypeToExternal = ReactionType.immediate;

  ReactionType get reactionTypeToExternal => __reactionTypeToExternal;

  void _resetReactionTypeToExternal() {
    __reactionTypeToExternal = ReactionType.immediate;
  }

  bool setReactionTypeDelayIfUIActive() {
    if (__reactionTypeToExternal == ReactionType.delay) {
      return false;
    }
    bool uiActive = ui.hasActiveUIComponent();
    if (uiActive) {
      __reactionTypeToExternal = ReactionType.delay;
      return true;
    }
    return false;
  }

  late final ShelfConfig config;

  bool __disposed = false;

  bool get disposed => __disposed;

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

  final List<Scalar> _rootScalars = [];

  List<Scalar> get rootScalars => [..._rootScalars];

  List<Scalar> get scalars {
    List<Scalar> ret = [];
    for (Scalar rootScalar in _rootScalars) {
      ret.add(rootScalar);
      ret.addAll(rootScalar.descendantScalars);
    }
    return ret;
  }

  final Map<String, Block> __blockMap = {};

  final List<Block> _rootBlocks = [];

  List<Block> get rootBlocks => [..._rootBlocks];

  List<Block> get blocks {
    List<Block> ret = [];
    for (Block rootBlock in _rootBlocks) {
      ret.add(rootBlock);
      ret.addAll(rootBlock.descendantBlocks);
    }
    return ret;
  }

  List<Block> get leafBlocks {
    List<Block> ret = [];
    for (Block block in __blockMap.values) {
      if (block.childBlocks.isEmpty) {
        ret.add(block);
      }
    }
    return ret;
  }

  bool _isStructError = false;

  String? _structError;

  bool get isStructError => _isStructError;

  String? get structError => _structError;

  int __lazyLoadId = 0;

  bool __lazyLoadLocked = false;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  late final _ShelfUIComponents ui = _ShelfUIComponents(shelf: this);

  late final _ShelfExternalUtils _shelfExternalUtils =
      _ShelfExternalUtils(this);

  int _debugInitQueryTasksCount = 0;

  int get debugInitQueryTasksCount => _debugInitQueryTasksCount;

  // ***************************************************************************
  // ***************************************************************************

  bool _hasReactionBookmark() {
    for (Block block in __blockMap.values) {
      bool has = block._hasReactionBookmark();
      if (has) {
        return true;
      }
    }
    for (Scalar scalar in __scalarMap.values) {
      bool has = scalar._hasReactionBookmark();
      if (has) {
        return true;
      }
    }
    return false;
  }

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
    List<Scalar> rootScalars = _shelfStruct.scalars;
    for (Scalar rootScalar in rootScalars) {
      rootScalar.parent = null;
      _rootScalars.add(rootScalar);
      __registerScalarCascade(rootScalar);
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
    // -------- SHELF INTERNAL EVENTS ------------
    //
    for (String blockName in __blockMap.keys) {
      Block listenerBlock = __blockMap[blockName]!;
      //
      if (listenerBlock.config.selfReQueryable) {
        listenerBlock._internalEffectedShelfMembers
            ._addReQueryBlock(listenerBlock);
      }
      if (listenerBlock.config.currentItemSelfRefreshable) {
        listenerBlock._internalEffectedShelfMembers
            ._addRefreshCurrItmBlock(listenerBlock);
      }
      for (Evt evt in listenerBlock.config.reQueryByInternalShelfEvents) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: '${evt.srcName}'. \n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          } else if (identical(listenerBlock, eventBlock)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'selfReQueryable:true' property. \n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // BLOCK EVENT
          eventBlock._internalEffectedShelfMembers
              ._addReQueryBlock(listenerBlock);
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "Configuration Error! --> No Scalar Name: ${evt.srcName}. \n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalEffectedShelfMembers
              ._addReQueryBlock(listenerBlock);
        }
      }
      //
      for (Evt evt
          in listenerBlock.config.refreshCurrItemByInternalShelfEvents) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: ${evt.srcName}. \n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > refreshCurrItemByInternalShelfEvents > '${evt.srcName}'.",
            );
          } else if (identical(listenerBlock, eventBlock)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'currentItemSelfRefreshable:true' property. \n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > refreshCurrItemByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // BLOCK EVENTS
          eventBlock._internalEffectedShelfMembers
              ._addRefreshCurrItmBlock(listenerBlock);
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "Configuration Error! --> No Scalar Name: ${evt.srcName}.\n"
              " ${getClassName(listenerBlock.shelf)} > registerStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > refreshCurrItemByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalEffectedShelfMembers
              ._addRefreshCurrItmBlock(listenerBlock);
        }
      }
    }
    //
    for (String scalarName in __scalarMap.keys) {
      Scalar listenerScalar = __scalarMap[scalarName]!;
      if (listenerScalar.config.selfReQueryable) {
        listenerScalar._internalEffectedShelfMembers
            ._addReQueryScalar(listenerScalar);
      }
      for (Evt evt in listenerScalar.config.reQueryByInternalShelfEvents) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: ${evt.srcName}. \n"
              " ${getClassName(listenerScalar.shelf)} > registerStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // BLOCK EVENT:
          eventBlock._internalEffectedShelfMembers
              ._addReQueryScalar(listenerScalar);
        }
        // SCALAR EVENT:
        else if (evt.srcType == SrcType.scalar) {
          Scalar? eventScalar = __scalarMap[evt.srcName];
          if (eventScalar == null) {
            throw ___registerError(
              "Configuration Error! --> No Scalar Name: ${evt.srcName}. \n"
              " ${getClassName(listenerScalar.shelf)} > registerStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          } else if (identical(listenerScalar, eventScalar)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'selfReQueryable:true' property.\n"
              " ${getClassName(listenerScalar.shelf)} > registerStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > reQueryByInternalShelfEvents > '${evt.srcName}'.",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalEffectedShelfMembers
              ._addReQueryScalar(listenerScalar);
        }
      }
    }
  }

  // ***************************************************************************
// ***************************************************************************

  void __registerScalarCascade(Scalar scalar) {
    if (__scalarMap.containsKey(scalar.name)) {
      throw ___registerError(
          "Duplicated scalar '${scalar.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.registerStructure() method");
    } else {
      __scalarMap[scalar.name] = scalar;
    }
    //
    scalar.shelf = this;
    if (scalar.registerFilterModelName != null) {
      FilterModel? filterModel =
          _shelfStruct.filterModels[scalar.registerFilterModelName!];
      if (filterModel == null) {
        throw ___registerError(
            "FilterModel not found '${scalar.registerFilterModelName}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      }
      //
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
            "The Scalar and its FilterModel must have the same FILTER_INPUT type.\n\n"
            " >> ${getClassName(scalar)}<FILTER_INPUT> = <$filterInputB> \n"
            " >> ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      // -----------------
      const Type filterCriteriaType = FilterCriteria;
      final filterCriteriaBase = filterCriteriaType.toString();
      final filterCriteriaBF = filterModel.getFilterCriteriaType().toString();
      final String filterCriteriaB = scalar.getFilterCriteriaType().toString();
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
            "The Scalar and its Filter-Model must have the same FILTER_CRITERIA type. \n"
            " >> ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
            " >> ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      filterModel._scalars.add(scalar);
      scalar._registeredOrDefaultFilterModel = filterModel;
    } else {
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
            "Filter-Criteria of '${getClassName(scalar)}' scalar must be '$filterCriteriaEmpty' "
            "because this scalar does not have a FILTER_MODEL.\n\n"
            " >> Currently, ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB>");
      }
    }
    //
    for (Scalar childScalar in scalar.childScalars) {
      __registerScalarCascade(childScalar);
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

  bool get isFullyPending {
    for (Scalar scalar in scalars) {
      if (scalar.dataState != DataState.pending) {
        return false;
      }
    }
    for (Block block in rootBlocks) {
      if (block.dataState != DataState.pending) {
        return false;
      }
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  EffectedShelfMembers _calculateEffectedShelfMembersByEvents(
    List<Event> events,
  ) {
    return _shelfExternalUtils.calculateEffectedShelfMembersByEvents(events);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<void> _startLoadDataForLazyUIComponentsIfNeed() async {
    print("\n\n\n@@@@@@@@@@@@@ START LAZY LOAD @@@@@@@@@");
    if (__lazyLoadLocked) {
      await Future.doWhile(
        () => Future.delayed(const Duration(milliseconds: 1))
            .then((_) => __lazyLoadLocked),
      );
    }
    //
    // IMPORTANT:
    //
    __lazyLoadLocked = true;

    // await Future.doWhile(
    //   () => Future.delayed(const Duration(milliseconds: 1))
    //       .then((_) => FlutterArtist.executor.isBusy),
    // );

    // New Code:
    // await Future.delayed(Duration(microseconds: 200));

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
    __lazyLoadId++;
    //
    await Future.delayed(
      const Duration(milliseconds: 0),
      () async {
        await __queryLazyList();
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __queryLazyList() async {
    print(">>>>>>>>>>>>>> QUERY LAZY LIST <<<<<<<<<<<<<<<<<<<<<<<<");
    //
    // Natural Query:
    //
    final XShelf xShelf = _XShelfShelfNaturalQuery(shelf: shelf);
    _LazyObjects lazyObjects = xShelf.getLazyObjectInfos();
    lazyObjects.printInfo();
    //
    if (lazyObjects.isEmpty) {
      print(">>>> LazyObjects is Empty <<<<");
      __lazyLoadLocked = false;
      // IMPORTANT: No Lazy entities, but need to refresh UIComponents:
      ui.updateAllUIComponents();
      return;
    }
    print("@@@@@@@@@@@@ Lazy Load - ID: $__lazyLoadId");
    print("@@@@@@@@@@@@ Lazy Load - Count: ${lazyObjects.count}");
    try {
      //
      // TODO: Handle Error:
      //
      xShelf._initQueryTasks();
      FlutterArtist._rootQueue._addXShelf(xShelf);
      await FlutterArtist.executor._executeTaskUnitQueue();
    } finally {
      __lazyLoadLocked = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _markReactionToExternalShelfEvents({
    required EffectedShelfMembers effectedShelfMembers,
  }) async {
    print(
        " ||-------------> [External Reaction] _markReactionToExternalShelfEvents: ${getClassName(this)} [LISTENER]");
    //
    for (String blockName in effectedShelfMembers._reQueryBlockMAP.keys) {
      Block block = __blockMap[blockName]!;
      block._blockReQryCon = _BlockReQryCon(
        parentItemId: block.parentItemId,
        filterCriteria: block.filterCriteria,
      );
    }
    //
    for (String blockName
        in effectedShelfMembers._refreshCurrItmBlockMAP.keys) {
      Block block = __blockMap[blockName]!;
      Object? itemId = block.currentItemId;
      block._blockItemRefreshCon = itemId == null
          ? null
          : _BlockItemRefreshCon(
              itemId: itemId,
            );
    }
    //
    for (String scalarName in effectedShelfMembers._reQueryScalarMAP.keys) {
      Scalar scalar = __scalarMap[scalarName]!;
      scalar._scalarReQryCon = _ScalarReQryCon(
        parentScalarValueId: scalar.parentScalarValueId, //
        filterCriteria: scalar.filterCriteria,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _addShelfExternalReactionTaskUnit() async {
    print(
        " ||-------------> [External Reaction] _addShelfExternalReactionTaskUnit: ${getClassName(this)} [LISTENER]");
    //
    final XShelf xShelf = _XShelfShelfExternalReaction(
      shelf: this,
    );
    //
    xShelf._initQueryTasks();
    // IMPORTANT: No need to call "execute".
    FlutterArtist._rootQueue._addXShelf(xShelf);
  }

  Future<ShelfDelayedReactionExecutionResult>
      executeDelayedExternalReactionTaskUnit() async {
    Actionable<ShelfDelayedReactionExecutionPrecheck> actionable =
        __canExecuteDelayedExternalReaction(checkBusy: true);

    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return ShelfDelayedReactionExecutionResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    _addShelfExternalReactionTaskUnit();
    await FlutterArtist.executor._executeTaskUnitQueue();
    return ShelfDelayedReactionExecutionResult();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfDelayedReactionExecutionPrecheck>
      __canExecuteDelayedExternalReaction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ShelfDelayedReactionExecutionPrecheck>.no(
        errCode: ShelfDelayedReactionExecutionPrecheck.busy,
      );
    }
    //
    return Actionable<ShelfDelayedReactionExecutionPrecheck>.yes();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfDelayedReactionExecutionPrecheck>
      canExecuteDelayedExternalReaction() {
    return __canExecuteDelayedExternalReaction(checkBusy: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "${getClassName(this)}($name)";
  }
}
