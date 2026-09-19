part of '../core.dart';

int __shelfSequence = 0;

abstract class Shelf extends _Core {
  Shelf get shelf => this;

  bool get deferReactions {
    Set<Type>? excludeDeferShelfTypes =
        FlutterArtist.backstage._defermentInfo?.excludeShelfTypes;
    if (excludeDeferShelfTypes == null) {
      return false;
    }
    if (excludeDeferShelfTypes.contains(this.runtimeType)) {
      return false;
    }
    return true;
  }

  late final debug = _ShelfDebugInfo(shelf: this);

  late final ShelfConfig config;
  late final ShelfEffectiveConfig effectiveConfig;

  void _markAsOrphaned(bool orphaned) {
    if (orphaned) {
      __orphanedAt = DateTime.now();
    } else {
      __orphanedAt = null;
    }
  }

  DateTime? __orphanedAt;

  DateTime? get orphanedAt => __orphanedAt;

  bool get markedAsOrphan => __orphanedAt != null;

  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All filterModels including the default filterModel.
  final List<FilterModel> _allFilterModels = [];

  List<String> get filterNames =>
      List.unmodifiable(_shelfStruct.filterModels.keys);

  // All formModels.
  final List<FormModel> _allFormModels = [];

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

  late final int _shelfLocalId = __shelfSequence++;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  String get shelfId => "${name}_$_shelfLocalId";

  late final ui = _ShelfUiComponents(shelf: this);

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
    FlutterArtist._clearActivitiesAndShelves();
    //
    return _createFatalAppError(message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __onInit() {
    _shelfStruct = defineShelfStructure();
    config = _shelfStruct._config;
    effectiveConfig = ShelfEffectiveConfig._fromConfig(_shelfStruct._config);

    for (String filterModelName in _shelfStruct.filterModels.keys) {
      FilterModel filterModel = _shelfStruct.filterModels[filterModelName]!;
      filterModel.name = filterModelName;
      filterModel.shelf = this;
      //
      _allFilterModels.add(filterModel);
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
  }

  // ***************************************************************************
// ***************************************************************************

  void __registerScalarCascade(Scalar scalar) {
    if (__scalarMap.containsKey(scalar.name)) {
      throw ___registerError(
          "Duplicate scalar '${scalar.name}' in '${getClassName(this)}'\n"
              "Double-check ${getClassName(
              this)}.defineShelfStructure() method");
    } else {
      __scalarMap[scalar.name] = scalar;
    }
    //
    scalar.shelf = this;
    if (scalar.registeredFilterModelName != null) {
      FilterModel? filterModel =
      _shelfStruct.filterModels[scalar.registeredFilterModelName!];
      if (filterModel == null) {
        throw ___registerError(
            "FilterModel not found '${scalar
                .registeredFilterModelName}' in '${getClassName(this)}'\n"
                "Double-check ${getClassName(
                this)}.defineShelfStructure() method");
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
                "or use the 'EmptyFilterInput' class to use in the '${getClassName(
                filterModel)}' declaration \n\n"
                " >> Currently, ${getClassName(
                filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      //
      if (filterInputBF != filterInputB) {
        throw ___registerError(
            "The Scalar and its FilterModel must have the same FILTER_INPUT type.\n\n"
                " >> ${getClassName(scalar)}<FILTER_INPUT> = <$filterInputB> \n"
                " >> ${getClassName(
                filterModel)}<FILTER_INPUT> = <$filterInputBF>");
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
                " >> Currently, ${getClassName(
                filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      if (filterCriteriaBF != filterCriteriaB) {
        throw ___registerError(
            "The Scalar and its Filter-Model must have the same FILTER_CRITERIA type. \n"
                " >> ${getClassName(
                scalar)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
                " >> ${getClassName(
                filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
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
            "Filter-Criteria of '${getClassName(
                scalar)}' scalar must be '$filterCriteriaEmpty' "
                "because this scalar does not have a FILTER_MODEL.\n\n"
                " >> Currently, ${getClassName(
                scalar)}<FILTER_CRITERIA> = <$filterCriteriaB>");
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
          "Duplicate block '${block.name}' in '${getClassName(this)}'\n"
              "Double-check ${getClassName(
              this)}.defineShelfStructure() method");
    } else {
      __blockMap[block.name] = block;
      if (block.formModel != null) {
        _allFormModels.add(block.formModel!);
      }
    }
    //
    block.shelf = this;
    if (block.registeredFilterModelName != null) {
      FilterModel? filterModel =
      _shelfStruct.filterModels[block.registeredFilterModelName!];
      if (filterModel == null) {
        throw ___registerError(
            "FilterModel not found '${block
                .registeredFilterModelName}' in '${getClassName(this)}'\n"
                "Double-check ${getClassName(
                this)}.defineShelfStructure() method");
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
                "or use the 'EmptyFilterInput' class to use in the '${getClassName(
                filterModel)}' declaration \n\n"
                " >> Currently, ${getClassName(
                filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      //
      if (filterInputBF != filterInputB) {
        throw ___registerError(
            "The Block and its FilterModel must have the same FILTER_INPUT type.\n\n"
                " >> ${getClassName(block)}<FILTER_INPUT> = <$filterInputB> \n"
                " >> ${getClassName(
                filterModel)}<FILTER_INPUT> = <$filterInputBF>");
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
                " >> Currently, ${getClassName(
                filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      if (filterCriteriaBF != filterCriteriaB) {
        throw ___registerError(
            "The Block and its Filter-Model must have the same FILTER_CRITERIA type. \n"
                " >> ${getClassName(
                block)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
                " >> ${getClassName(
                filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
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
            "Filter-Criteria of '${getClassName(
                block)}' block must be '$filterCriteriaEmpty' "
                "because this block does not have a FILTER_MODEL.\n\n"
                " >> Currently, ${getClassName(
                block)}<FILTER_CRITERIA> = <$filterCriteriaB>");
      }
    }
    //
    Type formInputB = FormInput;
    String formInputTypeB = formInputB.toString();
    String formInputTypeStr = block.getFormInputType().toString();

    if (formInputTypeStr == formInputTypeB) {
      throw ___registerError(
          "You need to create your own class that extends the '$formInputTypeB' class \n"
              "or use the 'EmptyFormInput' class to use in the '${getClassName(
              block)}' declaration \n\n"
              " >> Currently, ${getClassName(
              block)}<FORM_INPUT> = <$formInputTypeStr>");
    }
    //
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// ShelfStructure defineShelfStructure() {
  ///   return ShelfStructure(
  ///     filterModels: {
  ///       Song02aFilterModel.filterName: Song02aFilterModel(),
  ///     },
  ///     blocks: [
  ///       Song02aBlock(
  ///         name: Song02aBlock.blkName,
  ///         description: null,
  ///         config: BlockConfig(),
  ///         filterModelName: Song02aFilterModel.filterName,
  ///         formModel: null,
  ///         childBlocks: [],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  ShelfStructure defineShelfStructure();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugShelfStructureInspector() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugShelfStructureInspectorDialog.show(
      context: context,
      shelf: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugUiContextInspector() async {
    BuildContext context = FlutterArtistCore.context;
    await DebugUiContextInspectorDialog.show(
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

  FilterModel? findFilterModel(String filterModelName) {
    return _shelfStruct.filterModels[filterModelName];
  }

  bool get isFullyPending {
    for (Scalar scalar in rootScalars) {
      if (!scalar.dataState.isPending) {
        return false;
      }
    }
    for (Block block in rootBlocks) {
      if (!block.dataState.isPending) {
        return false;
      }
    }
    return true;
  }

  Future<void> _unitExecutionStarter({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XShelf thisXShelf,
  }) async {
    __assertThisXShelf(thisXShelf);

    print("####### - _unitExecutionStarter (_ShelfStarterExecutionUnit)");
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  // LOGIC: #0000
  Future<void> _startLoadDataForLazyUiComponentsIfNeed({
    required ExecutionTrace executionTrace,
  }) async {
    __lazyLoadId++;
    //
    executionTrace._addTraceStep(
      codeId: "#02000",
      shortDesc:
      "Find lazy model-components (block, scalar or formModel) that are in a state where they need to query or load data.",
    );
    //
    // Natural Query:
    //
    final XShelf xShelf = _XShelfShelfNaturalQuery(shelf: shelf);
    // _LazyObjects lazyObjects = xShelf.getLazyObjectInfos();
    // //
    // if (lazyObjects.isEmpty) {
    //   executionTrace._addTraceStep(
    //     codeId: "#02020",
    //     shortDesc:
    //         "No lazy model-components found. Just update All UI components and nothing else. "
    //         "Calling ${debugObjHtml(this)}.ui.updateAllUiComponents().",
    //     traceStepType: TraceStepType.nonControllableCalling,
    //   );
    //   // IMPORTANT: No Lazy entities, but need to refresh UiComponents:
    //   ui.updateAllUiComponents();
    //   FlutterArtist.storage.ui.updateAllUiComponents();
    //   return;
    // }
    // executionTrace._addTraceStep(
    //   codeId: "#02060",
    //   shortDesc: "Found some lazy model-components.\n"
    //       "${lazyObjects.toDebugString()}",
    //   traceStepType: TraceStepType.debug,
    // );
    try {
      executionTrace._addTraceStep(
        codeId: "#02100",
        shortDesc: "Create ${debugObjHtml(xShelf)} for <b>Natural-Load</b>.",
        note:
        "<b>XShelf</b> is a <b>RootQueueItem</b> and contains multiple <b>Execution Units</b>.",
      );
      executionTrace._addTraceStep(
        codeId: "#02120",
        shortDesc:
        "Calling ${debugObjHtml(
            xShelf)}._initQueryExecutionUnits() to create <b>Natural-Load</b> execution units...",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      // //
      // // TODO: Handle Error:
      // //
      // xShelf._initQueryExecutionUnits(executionTrace: executionTrace);
      //
      executionTrace._addTraceStep(
        codeId: "#02160",
        shortDesc:
        "Add ${debugObjHtml(xShelf)} (RootQueueItem) to <b>Root-Queue</b>.",
      );
      FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
      //
      executionTrace._addTraceStep(
        codeId: "#02200",
        shortDesc:
        "Calling <b>FlutterArtist.executor._executeExecutionUnitQueue()</b> "
            "to execute <b>RootQueueItem(s)</b> on the queue and its <b>Execution Units</b>...",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      await FlutterArtist.executor._executeExecutionUnitQueue();
    } finally {
      // Nothing
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename (+ `Visible` in name)
  bool hasAccumulatedEvents() {
    for (Block block in blocks) {
      if (block.hasAccumulatedEvents()) {
        return true;
      }
    }
    for (Scalar scalar in scalars) {
      if (scalar.hasAccumulatedEvents()) {
        return true;
      }
    }
    return false;
  }

  bool hasPendingOrStaleMember({required bool requiresVisible}) {
    for (Block block in blocks) {
      if (block.isPendingOrStale(requiresVisible: requiresVisible)) {
        return true;
      }
    }
    for (Scalar scalar in scalars) {
      if (scalar.isPendingOrStale(requiresVisible: requiresVisible)) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addShelfExternalReactionExecutionUnit({
    required ExecutionTrace executionTrace,
  }) async {
    executionTrace._addTraceStep(
      codeId: "#52000",
      shortDesc:
      "Creating <b>$_XShelfShelfExternalReaction</b> for ${debugObjHtml(
          this)}..",
    );
    //
    final XShelf xShelf = _XShelfShelfExternalReaction(
      shelf: this,
    );
    //
    // executionTrace._addTraceStep(
    //   codeId: "#52100",
    //   shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryExecutionUnits()..",
    //   traceStepType: TraceStepType.nonControllableCalling,
    // );
    // xShelf._initQueryExecutionUnits(executionTrace: executionTrace);
    //
    executionTrace._addTraceStep(
      codeId: "#52200",
      shortDesc: "Add ${debugObjHtml(xShelf)} to <b>RootQueue</b>.",
      traceStepType: TraceStepType.info,
    );
    // IMPORTANT: No need to call "execute".
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
  }

  Future<ShelfDeferredEventExecutionResult>
  executeDelayedExternalReactionExecutionUnit() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeDelayedExternalReactionExecutionUnit",
      parameters: null,
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#68000",
      shortDesc:
      "Checking before <b>executeDelayedExternalReactionExecutionUnit</b>..",
    );
    Actionable<ShelfDeferredEventExecutionPrecheck> actionable =
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
      executionTrace._addTraceStep(
        codeId: "#68100",
        shortDesc: "@actionable = ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return ShelfDeferredEventExecutionResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    _addShelfExternalReactionExecutionUnit(executionTrace: executionTrace);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return ShelfDeferredEventExecutionResult();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfDeferredEventExecutionPrecheck>
  __canExecuteDelayedExternalReaction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<ShelfDeferredEventExecutionPrecheck>.no(
        errCode: ShelfDeferredEventExecutionPrecheck.busy,
      );
    }
    //
    return Actionable<ShelfDeferredEventExecutionPrecheck>.yes();
  }

  @_PrecheckPrivateMethod()
  Actionable<ShelfDeferredEventExecutionPrecheck>
  canExecuteDelayedExternalReaction() {
    return __canExecuteDelayedExternalReaction(checkBusy: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "${getClassName(this)}($name)";
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXShelf(XShelf thisXShelf) {
    if (thisXShelf.shelf != this) {
      String message = "Error Assert shelf: ${thisXShelf.shelf} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
