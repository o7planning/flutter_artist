part of '../../core.dart';

int __xShelfSequence = 0;

abstract class XShelf extends XRootQueueItem {
  final XShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  late final __xShelfExecutionUnitQueue =
      _XShelfExecutionUnitQueue(xShelf: this);

  @override
  String get _fullName => "@XShelf-${shelf.name}";

  final Map<String, XFilterModel> xFilterModelMap = {};
  final Map<String, XFormModel> xFormModelMap = {};
  final Map<String, XScalar> xScalarMap = {};
  final Map<String, XBlock> xBlockMap = {};

  //
  final List<XBlock> allRootXBlocks = [];
  final List<XScalar> allRootXScalars = [];

  //
  final List<XBlock> allLeafXBlocks = [];
  final List<XScalar> allLeafXScalars = [];

  //
  final List<XScalar> allXScalars = [];
  final List<XBlock> allXBlocks = [];

  //
  final List<XFilterModel> allXFilterModels = [];
  final List<XFormModel> allXFormModels = [];

  late Set<XBlock> _frontierXBlocks;
  late Set<XScalar> _frontierXScalars;

  XBlock? __rootVipXBlock;

  XBlock? get rootVipXBlock => __rootVipXBlock;

  XScalar? __rootVipXScalar;

  XScalar? get rootVipXScalar => __rootVipXScalar;

  bool get naturalMode => xShelfType == XShelfType.naturalQuery;

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  XShelf({
    required this.xShelfType,
    required this.shelf,
  }) : xShelfId = __xShelfSequence++ {
    for (FilterModel filterModel in shelf._allFilterModels) {
      //
      // Create XFilterModel from filterModel.
      //
      final xFilterModel = filterModel._createXFilterModel(xShelf: this);
      //
      xFilterModelMap[filterModel.name] = xFilterModel;
      allXFilterModels.add(xFilterModel);
    }
    for (Scalar scalar in shelf.scalars) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      // Create XScalar via 'scalar._createXScalar' method
      // to have the same Generics Parameters with scalar.
      //
      final xScalar = scalar._createXScalar(
        xFilterModel: xFilterModel,
      );
      xFilterModel.xScalars.add(xScalar);
      allXScalars.add(xScalar);
      xScalarMap[scalar.name] = xScalar;
      //
      if (scalar.parent == null) {
        allRootXScalars.add(xScalar);
      }
      if (scalar.childScalars.isEmpty) {
        allLeafXScalars.add(xScalar);
      }
    }
    //
    for (Scalar scalar in shelf.scalars) {
      XScalar xScalar = xScalarMap[scalar.name]!;
      Scalar? parent = scalar.parent;
      if (parent != null) {
        XScalar xScalarParent = xScalarMap[parent.name]!;
        xScalar.parentXScalar = xScalarParent;
        xScalarParent.childXScalars.add(xScalar);
      } else {
        xScalar.parentXScalar = null;
      }
    }
    //
    for (Block block in shelf.blocks) {
      final FormModel? formModel = block.formModel;
      XFormModel? xFormModel;
      if (formModel != null) {
        //
        // Create new XFormModel via 'formModel._createXFormModel' method
        // to have the same Generics Parameters with block.
        //
        xFormModel = formModel._createXFormModel(formInput: null);
        allXFormModels.add(xFormModel);
        xFormModelMap[formModel.block.name] = xFormModel;
      }
      //
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      // Create new XBlock via 'block._createXBlock' method
      // to have the same Generics Parameters with block.
      //
      final xBlock = block._createXBlock(
        xFilterModel: xFilterModel,
        xFormModel: xFormModel,
      );
      xFormModel?.xBlock = xBlock;
      //
      xFilterModel.xBlocks.add(xBlock);
      allXBlocks.add(xBlock);
      xBlockMap[block.name] = xBlock;
      //
      if (block.parent == null) {
        allRootXBlocks.add(xBlock);
      }
      if (block.childBlocks.isEmpty) {
        allLeafXBlocks.add(xBlock);
      }
    }
    //
    for (Block block in shelf.blocks) {
      XBlock xBlock = xBlockMap[block.name]!;
      Block? parent = block.parent;
      if (parent != null) {
        XBlock xBlockParent = xBlockMap[parent.name]!;
        xBlock.parentXBlock = xBlockParent;
        xBlockParent.childXBlocks.add(xBlock);
      } else {
        xBlock.parentXBlock = null;
      }
    }
    _updateFromShelfForFirstTime();
    _frontierXBlocks = _determineFrontierXBlocks();
    _frontierXScalars = _determineFrontierXScalars();
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _updateFromShelfForFirstTime() {
    for (XScalar leafXScalar in allLeafXScalars) {
      XScalar? xScalar = leafXScalar;
      QryHint maxQryHint = leafXScalar.queryHint;
      while (xScalar != null) {
        maxQryHint = QryHint.max(maxQryHint, xScalar.queryHint);
        final ScalarDataState dataState = xScalar.scalar.dataState;
        bool hasActiveUiX = xScalar.scalar.ui.hasActiveScalarBaseView(
          alsoCheckChildren: true,
        );
        if (hasActiveUiX) {
          switch (dataState) {
            case ScalarDataStateNone():
              break;
            case ScalarDataStateLoadedFresh():
              break;
            case ScalarDataStatePending():
              maxQryHint = QryHint.force;
            case ScalarDataStateLoadedStale():
              maxQryHint = QryHint.force;
          }
        }
        // !hasActiveUiX
        else {
          switch (dataState) {
            case ScalarDataStateNone():
              break;
            case ScalarDataStateLoadedFresh():
              break;
            case ScalarDataStatePending():
              break;
            case ScalarDataStateLoadedStale():
              break;
          }
        }
        xScalar.setQueryHintToGreater(maxQryHint);
        xScalar = xScalar.parentXScalar;
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (xBlock != null) {
        bool blockXBlockRep =
            xBlock.block.ui.hasActiveUiComponentBlockRepresentative(
          alsoCheckChildren: true,
        );
        if (blockXBlockRep) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isStale) {
            xBlock.setQueryHintToGreater(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUiComponent()) {
          if (xFormModel.formModel.dataState.isPending ||
              xFormModel.formModel.dataState.isFatalError ||
              xFormModel.formModel.dataState.isNone) {
            // Test case: [39b]
            xFormModel.lazy = true;
            if (naturalMode) {
              xFormModel.setForceType(ForceType.decidedAtRuntime);
            } else {
              xFormModel.setForceType(ForceType.force);
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Set<XBlock> _determineFrontierXBlocks() {
    final Set<XBlock> result = {};
    for (XBlock xBlock in allRootXBlocks) {
      _collectFrontierXBlockCascade(xBlock: xBlock, result: result);
    }
    return result;
  }

  void _collectFrontierXBlockCascade({
    required XBlock xBlock,
    required Set<XBlock> result,
  }) {
    final BlockDataState dataState = xBlock.block.dataState;
    if (dataState.isPending || dataState.isStale) {
      result.add(xBlock);
    } else {
      for (XBlock childXBlock in xBlock.childXBlocks) {
        _collectFrontierXBlockCascade(xBlock: childXBlock, result: result);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Set<XScalar> _determineFrontierXScalars() {
    final Set<XScalar> result = {};
    for (XScalar xScalar in allRootXScalars) {
      _collectFrontierXScalarCascade(xScalar: xScalar, result: result);
    }
    return result;
  }

  void _collectFrontierXScalarCascade({
    required XScalar xScalar,
    required Set<XScalar> result,
  }) {
    final ScalarDataState dataState = xScalar.scalar.dataState;
    if (dataState.isPending || dataState.isStale) {
      result.add(xScalar);
    } else {
      for (XScalar childXScalar in xScalar.childXScalars) {
        _collectFrontierXScalarCascade(xScalar: childXScalar, result: result);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  NextExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    PrintUtils.debug(debug,
        "\nBEGIN >>> ${getClassNameWithoutGenerics(this)}._getNextExecutionUnit()...");
    NextExecutionUnit? next = _findBlockNextExecutionUnit(debug: debug);
    if (next != null) {
      return next;
    }
    return null;
  }

  // ***************************************************************************

  NextExecutionUnit? _findBlockNextExecutionUnit({required bool debug}) {
    for (final root in allRootXBlocks) {
      final NextExecutionUnit? next =
          _findBlockNextExecutionUnitCascade(xBlock: root, debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }
    return null;
  }

  NextExecutionUnit? _findBlockNextExecutionUnitCascade({
    required XBlock xBlock,
    required bool debug,
  }) {
    NextExecutionUnit next1 = xBlock._getNextExecutionUnit(debug: debug);
    if (next1.yes) {
      return next1;
    }
    for (final XBlock childXBlock in xBlock.childXBlocks) {
      NextExecutionUnit? next2 =
          _findBlockNextExecutionUnitCascade(xBlock: childXBlock, debug: debug);
      if (next2 != null && next2.yes) {
        return next2;
      }
    }
    return null;
  }

  // ***************************************************************************

  XScalar? _findScalarNextExecutionUnit() {
    for (final root in allRootXScalars) {
      final XScalar? result = _findScalarNextExecutionUnitCascade(root);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  XScalar? _findScalarNextExecutionUnitCascade(XScalar xScalar) {
    if (xScalar.isLazy) {
      return xScalar;
    }
    for (final XScalar childXScalar in xScalar.childXScalars) {
      final XScalar? result = _findScalarNextExecutionUnitCascade(childXScalar);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void setRootVipXBlock({required XBlock descendantXBlock}) {
    __rootVipXBlock = descendantXBlock.rootXBlock;
  }

  void setRootVipXScalar({required XScalar descendantXScalar}) {
    __rootVipXScalar = descendantXScalar.rootXScalar;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  _LazyObjects getLazyObjectInfos() {
    final _LazyObjects ret = _LazyObjects();
    for (XBlock xBlock in allXBlocks) {
      // Test Case: [06b] - Only Filter in the Screen.
      final XFilterModel xFilterModel = xBlock.xFilterModel;
      if (xFilterModel.isVisibleNeedToQuery()) {
        ret.addLazyFilterModel(filterModel: xFilterModel.filterModel);
      }
      if (xBlock.queryHint != QryHint.none) {
        ret.addLazyBlock(
          block: xBlock.block,
          queryHint: xBlock.queryHint,
        );
      }
    }
    for (XScalar xScalar in allXScalars) {
      final XFilterModel xFilterModel = xScalar.xFilterModel;
      if (xFilterModel.isVisibleNeedToQuery()) {
        ret.addLazyFilterModel(filterModel: xFilterModel.filterModel);
      }
      if (xScalar.queryHint != QryHint.none) {
        ret.addLazyScalar(scalar: xScalar.scalar);
      }
    }
    for (XFormModel xFormModel in allXFormModels) {
      if (xFormModel.lazy) {
        ret.addLazyFormModel(formModel: xFormModel.formModel);
      }
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  //
  // IMPORTANT: Sync Method.
  //
  void _updateInternalReactionByEvtBlock({
    required ExecutionTrace executionTrace,
    required XBlock eventXBlock,
    required bool forceRequeryEventBlock,
    required BlockViewportSyncStrategy? viewportSyncStrategyEventBlock,
  }) {
    __assertXShelf(eventXBlock.xShelf);
    //
    if (__rootVipXBlock != eventXBlock.rootXBlock) {
      throw "Development Logic Error";
    }

    final EffectedShelfMembers effectedShelfMembers =
        eventXBlock.block._internalEffectedShelfMembers;

    executionTrace._addTraceStep(
      codeId: "#10000",
      shortDesc:
          "Registered Effected Shelf Members:${effectedShelfMembers.getDebugInfoHtml()}",
      traceStepType: TraceStepType.debug,
    );

    if (forceRequeryEventBlock) {
      final forceQryHint = QryHint.force;
      //
      executionTrace._addTraceStep(
        codeId: "#10100",
        shortDesc:
            "Set ${debugObjHtml(eventXBlock.block)} qryHint: ${debugObjHtml(forceQryHint)}.",
      );
      eventXBlock.setQueryHintToGreater(forceQryHint);
      if (viewportSyncStrategyEventBlock != null) {
        eventXBlock.setViewportSyncStrategy(viewportSyncStrategyEventBlock);
      }
    }
    //
    Set<String> listenerBlockNames = {}
      ..addAll(effectedShelfMembers._requeryBlockMAP.keys)
      ..addAll(effectedShelfMembers._refreshCurrItmBlockMAP.keys);

    for (String listenerBlkName in listenerBlockNames) {
      final Block? reQryBlock =
          effectedShelfMembers._requeryBlockMAP[listenerBlkName];
      final Block? refreshCurrBlock =
          effectedShelfMembers._refreshCurrItmBlockMAP[listenerBlkName];
      //
      bool hasXBlockRep = false;
      bool hasXItemRep = false;
      //  bool blockVisible = false;
      QryHint queryHint = QryHint.none;
      bool forceReloadCurrItem = false;
      //
      if (reQryBlock != null) {
        // @@@hasActiveBlockFragment
        hasXBlockRep = reQryBlock.ui.hasActiveUiComponentBlockRepresentative(
          alsoCheckChildren: true,
        );
        queryHint = hasXBlockRep ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        // @@@hasActiveBlockFragment
        hasXItemRep =
            refreshCurrBlock.ui.hasActiveUiComponentItemRepresentative(
          alsoCheckChildren: true,
        );
        forceReloadCurrItem = true;
        XBlock refreshCurrXBlock = findXBlockByName(refreshCurrBlock.name)!;
        refreshCurrXBlock.setCurrItemToReload(refreshCurrBlock.currentItem);
      }
      //
      XBlock xBlock = findXBlockByName(listenerBlkName)!;
      xBlock.setQueryHintToGreater(queryHint);
      if (forceReloadCurrItem) {
        xBlock.setForceReloadCurrItem(forceReloadCurrItem);
      }
    }
    //
    for (Scalar s in effectedShelfMembers._requeryScalarMAP.values) {
      String scalarName = s.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool hasActiveUI = s.ui.hasActiveUiComponent();
      if (hasActiveUI) {
        //
        xScalar.setQueryHintToGreater(QryHint.force);
      } else {
        //
        xScalar.setQueryHintToGreater(QryHint.markAsPending);
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (true) {
        if (xBlock == null) {
          break;
        }
        // @@@hasActiveBlockFragment
        bool hasXBlockRep =
            xBlock.block.ui.hasActiveUiComponentBlockRepresentative(
          alsoCheckChildren: true,
        );
        if (hasXBlockRep) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isStale) {
            xBlock.setQueryHintToGreater(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;

        // Current: updateInternalReactionByEvtBlock.
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUiComponent()) {
          if (xFormModel.formModel.dataState.isPending ||
              xFormModel.formModel.dataState.isFatalError ||
              xFormModel.formModel.dataState.isNone) {
            xFormModel.lazy = true;

            if (naturalMode) {
              // Never Run.
              xFormModel.setForceType(ForceType.force);
            } else {
              xFormModel.setForceType(ForceType.decidedAtRuntime);
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  // debug [#01000] _EmptyExecutionUnit
  @Deprecated("Xoa di")
  void _initQueryExecutionUnits({required ExecutionTrace executionTrace}) {
    if (rootVipXScalar != null && rootVipXBlock != null) {
      // throw "Development Logic Error";
    }
    shelf.debug._initQueryExecutionUnitsCount++;
    //
    executionTrace._addTraceStep(
      codeId: "#01000",
      shortDesc: toDebugXShelfStateAsHtml(),
      traceStepType: TraceStepType.debug,
    );
    //
    final executionUnit = _ShelfStarterExecutionUnit(
      xShelf: this,
    );
    executionTrace._addTraceStep(
      codeId: "#01060",
      shortDesc:
          "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
      traceStepType: TraceStepType.addExecutionUnit,
    );
    //
    _addExecutionUnit(
      executionUnit: executionUnit,
      toMainQueue: true,
    );
  }

  // debug [#01000]
  @Deprecated("No longer used")
  void _initQueryExecutionUnitsOLD({required ExecutionTrace executionTrace}) {
    if (rootVipXScalar != null && rootVipXBlock != null) {
      throw "Development Logic Error";
    }
    shelf.debug._initQueryExecutionUnitsCount++;
    //
    executionTrace._addTraceStep(
      codeId: "#01000",
      shortDesc: toDebugXShelfStateAsHtml(),
      traceStepType: TraceStepType.debug,
    );
    //
    final bool toMainQueue = false;
    //
    if (xShelfType == XShelfType.naturalQuery) {
      for (XFilterModel xFilterModel in allXFilterModels) {
        if (!xFilterModel.isVisibleNeedToQuery()) {
          continue;
        }
        final executionUnit = _FilterModelLoadDataExecutionUnit(
          xFilterModel: xFilterModel,
          executionTodo: FilterModelTodoLoad(),
        );
        executionTrace._addTraceStep(
          codeId: "#01060",
          shortDesc:
              "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
          traceStepType: TraceStepType.addExecutionUnit,
        );
        //
        // Execute xFilterModel first!!
        //
        _addExecutionUnit(
          executionUnit: executionUnit,
          toMainQueue: toMainQueue,
        );
      }
    }
    //
    if (rootVipXScalar != null) {
      final executionUnit = _ScalarQueryExecutionUnit(
        xScalar: rootVipXScalar!,
      );
      executionTrace._addTraceStep(
        codeId: "#01080",
        shortDesc:
            "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
        traceStepType: TraceStepType.addExecutionUnit,
      );
      //
      // Execute vipXScalar before XBlock(s)!!
      //
      _addExecutionUnit(
        executionUnit: executionUnit,
        toMainQueue: toMainQueue,
      );
    }
    //
    else if (rootVipXBlock != null) {
      final executionUnit = _BlockQueryExecutionUnit(
        xBlock: rootVipXBlock!,
        blockTodoQuery: null,
      );
      executionTrace._addTraceStep(
        codeId: "#01120",
        shortDesc:
            "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
        traceStepType: TraceStepType.addExecutionUnit,
      );
      //
      // Execute rootVipXBlock!!
      //
      _addExecutionUnit(
        executionUnit: executionUnit,
        toMainQueue: toMainQueue,
      );
    }
    //
    for (XScalar xScalar in allRootXScalars) {
      if (xScalar != rootVipXScalar) {
        final executionUnit = _ScalarQueryExecutionUnit(
          xScalar: xScalar,
        );
        executionTrace._addTraceStep(
          codeId: "#01160",
          shortDesc:
              "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
          traceStepType: TraceStepType.addExecutionUnit,
        );
        _addExecutionUnit(
          executionUnit: executionUnit,
          toMainQueue: toMainQueue,
        );
      }
    }
    //
    for (XBlock rootXBlock in allRootXBlocks) {
      if (rootXBlock != rootVipXBlock) {
        final executionUnit = _BlockQueryExecutionUnit(
          xBlock: rootXBlock,
          blockTodoQuery: null,
        );
        executionTrace._addTraceStep(
          codeId: "#01200",
          shortDesc:
              "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
          traceStepType: TraceStepType.addExecutionUnit,
        );
        _addExecutionUnit(
          executionUnit: executionUnit,
          toMainQueue: toMainQueue,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  String toDebugXShelfStateAsHtml() {
    String s = "${debugObjHtml(this)}\n"
        " --- STATE BEFORE CREATING EXECUTION UNITS ---";
    for (String key in xBlockMap.keys) {
      final XBlock xBlock = xBlockMap[key]!;
      s += "\n${xBlock.toDebugHtmlString()}";
    }
    for (String key in xScalarMap.keys) {
      final XScalar xScalar = xScalarMap[key]!;
      s += "\n${xScalar.toDebugHtmlString()}";
    }
    return s;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  XFilterModel? findXFilterModelByName(String name) {
    return xFilterModelMap[name];
  }

  XBlock? findXBlockByName(String name) {
    return xBlockMap[name];
  }

  XScalar? findXScalarByName(String name) {
    return xScalarMap[name];
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  @override
  DebugXRootQueueItem toDebugXRootQueueItem() {
    return __xShelfExecutionUnitQueue.toDebugXRootQueueItem();
  }

  @override
  bool isEmptyExecutionUnit() {
    return __xShelfExecutionUnitQueue.isEmpty;
  }

  _ShelfMemberExecutionUnit? _getNextExecutionUnitOLD() {
    return __xShelfExecutionUnitQueue.getNextExecutionUnit();
  }

  void _addExecutionUnit({
    required _ShelfMemberExecutionUnit executionUnit,
    bool toMainQueue = true,
  }) {
    if (executionUnit.xShelf != this) {
      throw FatalAppError(
        errorMessage: "Development Logic Error.",
      );
    }
    __xShelfExecutionUnitQueue.addExecutionUnit(
      executionUnit: executionUnit,
      toMainQueue: toMainQueue,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    for (XScalar xScalar in allXScalars) {
      if (xScalar.queryHint != QryHint.none) {
        xScalar.printInfo();
      }
    }
    for (XBlock xBlock in allRootXBlocks) {
      xBlock.printInfoCascade();
    }
    for (XFormModel xFormModel in allXFormModels) {
      xFormModel.printInfo();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __assertXShelf(XShelf xShelf) {
    if (xShelf != this) {
      String message = "Error Assert xShelf: $xShelf - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
