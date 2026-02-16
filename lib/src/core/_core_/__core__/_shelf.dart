part of '../core.dart';

abstract class Shelf extends _Core {
  Shelf get shelf => this;

  late final ShelfConfig config;

  bool __disposed = false;

  bool get disposed => __disposed;

  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All filterModels including the default filterModel.
  final List<FilterModel> _allFilterModels = [];

  List<String> get filterNames =>
      List.unmodifiable(_shelfStruct.filterModels.keys);

  // All formModels.
  final List<FormModel> _allFormModels = [];

  final Map<String, Hook> __hookMap = {};

  final List<Hook> __hooks = [];

  List<Hook> get hooks => List.unmodifiable(__hooks);

  final Map<String, Scalar> __scalarMap = {};

  final List<Scalar> _rootScalars = [];

  List<Scalar> get rootScalars => List.unmodifiable(_rootScalars);

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

  List<Block> get rootBlocks => List.unmodifiable(_rootBlocks);

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

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  late final ui = _ShelfUiComponents(shelf: this);

  late final _shelfExternalUtils = _ShelfExternalUtils(this);

  int _debugInitQueryTaskUnitsCount = 0;

  int get debugInitQueryTasksCount => _debugInitQueryTaskUnitsCount;

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
    _shelfStruct = registerShelfStructure();
    config = _shelfStruct._config;

    for (String filterModelName in _shelfStruct.filterModels.keys) {
      FilterModel filterModel = _shelfStruct.filterModels[filterModelName]!;
      filterModel.name = filterModelName;
      filterModel.shelf = this;
      //
      _allFilterModels.add(filterModel);
    }
    //
    // Hook:
    //
    final List<Hook> hooks = _shelfStruct.hooks;
    for (Hook hook in hooks) {
      if (__hookMap.containsKey(hook.name)) {
        throw ___registerError(
            "Duplicated Hook '${hook.name}' in '${getClassName(this)}'"
            "\nDouble-check ${getClassName(this)}.registerShelfStructure() method");
      } else {
        __hookMap[hook.name] = hook;
      }
      hook.shelf = this;
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
      if (listenerBlock
          .config.onInternalShelfEvents.blockLevelSelfReactionEnabled) {
        listenerBlock._internalEffectedShelfMembers
            ._addReQueryBlock(listenerBlock);
      }
      if (listenerBlock
          .config.onInternalShelfEvents.currentItemSelfReactionEnabled) {
        listenerBlock._internalEffectedShelfMembers
            ._addRefreshCurrItmBlock(listenerBlock);
      }
      for (Evt evt
          in listenerBlock.config.onInternalShelfEvents.blockLevelReactionTo) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: '${evt.srcName}'. \n"
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeBlockLevelReactionToEvts > '${evt.srcName}'.",
            );
          } else if (identical(listenerBlock, eventBlock)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'selfReQueryable:true' property. \n"
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeBlockLevelReactionToEvts > '${evt.srcName}'.",
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
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeScalarLevelReactionToEvts > '${evt.srcName}'.",
            );
          }
          // SCALAR EVENT: update (Only One Events).
          eventScalar._internalEffectedShelfMembers
              ._addReQueryBlock(listenerBlock);
        }
      }
      //
      for (Evt evt
          in listenerBlock.config.onInternalShelfEvents.itemLevelReactionTo) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: ${evt.srcName}. \n"
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeItemLevelReactionToEvts > '${evt.srcName}'.",
            );
          } else if (identical(listenerBlock, eventBlock)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'currentItemSelfRefreshable:true' property. \n"
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeItemLevelReactionToEvts > '${evt.srcName}'.",
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
              " ${getClassName(listenerBlock.shelf)} > registerShelfStructure > ShelfStructure > blocks > ${getClassName(listenerBlock)}"
              " > config > executeItemLevelReactionToEvts > '${evt.srcName}'.",
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
      if (listenerScalar
          .config.onInternalShelfEvents.scalarLevelSelfReactionEnabled) {
        listenerScalar._internalEffectedShelfMembers
            ._addReQueryScalar(listenerScalar);
      }
      for (Evt evt in listenerScalar
          .config.onInternalShelfEvents.scalarLevelReactionTo) {
        // BLOCK EVENT:
        if (evt.srcType == SrcType.block) {
          Block? eventBlock = __blockMap[evt.srcName];
          if (eventBlock == null) {
            throw ___registerError(
              "Configuration Error! --> No Block Name: ${evt.srcName}. \n"
              " ${getClassName(listenerScalar.shelf)} > registerShelfStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > executeBlockLevelReactionToEvts > '${evt.srcName}'.",
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
              " ${getClassName(listenerScalar.shelf)} > registerShelfStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > executeScalarLevelReactionToEvts > '${evt.srcName}'.",
            );
          } else if (identical(listenerScalar, eventScalar)) {
            throw ___registerError(
              "Configuration Error! --> Do not use: '${evt.srcName}', let use 'selfReQueryable:true' property.\n"
              " ${getClassName(listenerScalar.shelf)} > registerShelfStructure > ShelfStructure > scalars > ${getClassName(listenerScalar)}"
              " > config > executeScalarLevelReactionToEvts > '${evt.srcName}'.",
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
          "Double-check ${getClassName(this)}.registerShelfStructure() method");
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
            "Double-check ${getClassName(this)}.registerShelfStructure() method");
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
          "Double-check ${getClassName(this)}.registerShelfStructure() method");
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
            "Double-check ${getClassName(this)}.registerShelfStructure() method");
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
    Type formInputB = FormInput;
    String formInputTypeB = formInputB.toString();
    String formInputTypeStr = block.getFormInputType().toString();

    if (formInputTypeStr == formInputTypeB) {
      throw ___registerError(
          "You need to create your own class that extends the '$formInputTypeB' class \n"
          "or use the 'EmptyFormInput' class to use in the '${getClassName(block)}' declaration \n\n"
          " >> Currently, ${getClassName(block)}<FORM_INPUT> = <$formInputTypeStr>");
    }
    //
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ShelfStructure registerShelfStructure();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugShelfStructureViewerDialog() async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    //
    await DebugShelfStructureViewerDialog.open(
      context: context,
      shelf: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFaUiComponentsViewerDialog() async {
    BuildContext context =
        FlutterArtist.coreFeaturesAdapter.getCurrentContext();
    await DebugUiComponentsViewerDialog.open(
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

  Hook? findHook(String hookName) {
    return __hookMap[hookName];
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

  // LOGIC: #0000
  Future<void> _startLoadDataForLazyUiComponentsIfNeed({
    required MasterFlowItem masterFlowItem,
  }) async {
    __lazyLoadId++;
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#02000",
      shortDesc:
          "Find lazy model-components (block, scalar or formModel) that are in a state where they need to query or load data.",
    );
    //
    // Natural Query:
    //
    final XShelf xShelf = _XShelfShelfNaturalQuery(shelf: shelf);
    _LazyObjects lazyObjects = xShelf.getLazyObjectInfos();
    //
    if (lazyObjects.isEmpty) {
      masterFlowItem._addLineFlowItem(
        codeId: "#02020",
        shortDesc:
            "No lazy model-components found. Just update All UI components and nothing else. "
            "Calling ${debugObjHtml(this)}.ui.updateAllUiComponents().",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      // IMPORTANT: No Lazy entities, but need to refresh UiComponents:
      ui.updateAllUiComponents();
      FlutterArtist.storage.ui.updateAllUiComponents();
      return;
    }
    masterFlowItem._addLineFlowItem(
      codeId: "#02060",
      shortDesc: "Found some lazy model-components.\n"
          "${lazyObjects.toDebugString()}",
      lineFlowType: LineFlowType.debug,
    );
    try {
      masterFlowItem._addLineFlowItem(
        codeId: "#02100",
        shortDesc: "Create ${debugObjHtml(xShelf)} for <b>Natural-Load</b>.",
        note:
            "<b>XShelf</b> is a <b>RootQueueItem</b> and contains multiple <b>Task Units</b>.",
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#02120",
        shortDesc:
            "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits() to create <b>Natural-Load</b> task units...",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      //
      // TODO: Handle Error:
      //
      xShelf._initQueryTaskUnits(masterFlowItem: masterFlowItem);
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#02160",
        shortDesc:
            "Add ${debugObjHtml(xShelf)} (RootQueueItem) to <b>Root-Queue</b>.",
      );
      FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#02200",
        shortDesc:
            "Calling <b>FlutterArtist.executor._executeTaskUnitQueue()</b> "
            "to execute <b>RootQueueItem(s)</b> on the queue and its <b>Task Units</b>...",
        lineFlowType: LineFlowType.nonControllableCalling,
      );
      await FlutterArtist.executor._executeTaskUnitQueue();
    } finally {
      // Nothing
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _markReactionToExternalShelfEvents({
    required MasterFlowItem masterFlowItem,
    required EffectedShelfMembers effectedShelfMembers,
  }) async {
    for (String blockName in effectedShelfMembers._reQueryBlockMAP.keys) {
      Block block = __blockMap[blockName]!;
      final blockReQryCondition = _BlockReQryCon(
        parentItemId: block.parentBlockCurrentItemId,
        filterCriteria: block.filterCriteria,
      );
      block._blockReQryCondition = blockReQryCondition;
      masterFlowItem._addLineFlowItem(
        codeId: "#50000",
        shortDesc: " - <b>$blockName</b>:"
            "\n  --> @blockReQryCondition: <b>$blockReQryCondition</b>.",
      );
    }
    //
    for (String blockName
        in effectedShelfMembers._refreshCurrItmBlockMAP.keys) {
      Block block = __blockMap[blockName]!;
      Object? itemId = block.currentItemId;
      final blockItemRefreshCondition = itemId == null
          ? null
          : _BlockItemRefreshCon(
              itemId: itemId,
            );
      block._blockItemRefreshCondition = blockItemRefreshCondition;
      masterFlowItem._addLineFlowItem(
        codeId: "#50100",
        shortDesc: " - <b>$blockName</b>:"
            "\n  --> @blockItemRefreshCondition: <b>$blockItemRefreshCondition</b>.",
      );
    }
    //
    for (String scalarName in effectedShelfMembers._reQueryScalarMAP.keys) {
      Scalar scalar = __scalarMap[scalarName]!;
      final scalarReQryCondition = _ScalarReQryCon(
        parentScalarValueId: scalar.parentScalarValueId, //
        filterCriteria: scalar.filterCriteria,
      );
      scalar._scalarReQryCondition = scalarReQryCondition;
      //
      masterFlowItem._addLineFlowItem(
        codeId: "#50200",
        shortDesc: " - <b>$scalarName</b>:"
            "\n  --> @scalarReQryCondition: <b>$scalarReQryCondition</b>.",
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addShelfExternalReactionTaskUnit({
    required MasterFlowItem masterFlowItem,
  }) async {
    masterFlowItem._addLineFlowItem(
      codeId: "#52000",
      shortDesc:
          "Creating <b>$_XShelfShelfExternalReaction</b> for ${debugObjHtml(this)}..",
    );
    //
    final XShelf xShelf = _XShelfShelfExternalReaction(
      shelf: this,
    );
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#52100",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits()..",
      lineFlowType: LineFlowType.nonControllableCalling,
    );
    xShelf._initQueryTaskUnits(masterFlowItem: masterFlowItem);
    //
    masterFlowItem._addLineFlowItem(
      codeId: "#52200",
      shortDesc: "Add ${debugObjHtml(xShelf)} to <b>RootQueue</b>.",
      lineFlowType: LineFlowType.info,
    );
    // IMPORTANT: No need to call "execute".
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
  }

  Future<ShelfQueuedEventExecutionResult>
      executeDelayedExternalReactionTaskUnit() async {
    final masterFlowItem = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeDelayedExternalReactionTaskUnit",
      parameters: null,
      navigate: null,
      isLibMethod: true,
    );
    masterFlowItem._addLineFlowItem(
      codeId: "#68000",
      shortDesc:
          "Checking before <b>executeDelayedExternalReactionTaskUnit</b>..",
    );
    Actionable<ShelfQueuedEventExecutionPrecheck> actionable =
        __canExecuteDelayedExternalReaction(checkBusy: true);
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: null,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      masterFlowItem._addLineFlowItem(
        codeId: "#68100",
        shortDesc: "@actionable = ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return ShelfQueuedEventExecutionResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    _addShelfExternalReactionTaskUnit(masterFlowItem: masterFlowItem);
    await FlutterArtist.executor._executeTaskUnitQueue();
    return ShelfQueuedEventExecutionResult();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfQueuedEventExecutionPrecheck>
      __canExecuteDelayedExternalReaction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ShelfQueuedEventExecutionPrecheck>.no(
        errCode: ShelfQueuedEventExecutionPrecheck.busy,
      );
    }
    //
    return Actionable<ShelfQueuedEventExecutionPrecheck>.yes();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfQueuedEventExecutionPrecheck>
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
