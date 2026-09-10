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
  // ***************************************************************************

  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    PrintUtils.debug(debug,
        "\nBEGIN >>> ${getClassNameWithoutGenerics(this)}._getNextExecutionUnit()...");
    NxtExecutionUnit? next = _findBlockNextExecutionUnit(debug: debug);
    if (next != null) {
      return next;
    }
    return null;
  }

  // ***************************************************************************

  NxtExecutionUnit? _findBlockNextExecutionUnit({required bool debug}) {
    for (final root in allRootXBlocks) {
      final NxtExecutionUnit? next =
          _findBlockNextExecutionUnitCascade(xBlock: root, debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }
    return null;
  }

  NxtExecutionUnit? _findBlockNextExecutionUnitCascade({
    required XBlock xBlock,
    required bool debug,
  }) {
    NxtExecutionUnit next1 = xBlock._getNextExecutionUnit(debug: debug);
    if (next1.yes) {
      return next1;
    }
    for (final XBlock childXBlock in xBlock.childXBlocks) {
      NxtExecutionUnit? next2 =
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

  // debug [#01000] _EmptyExecutionUnit
  @Deprecated("Xoa di")
  void _initQueryExecutionUnits({required ExecutionTrace executionTrace}) {
    // if (rootVipXScalar != null && rootVipXBlock != null) {
    //   // throw "Development Logic Error";
    // }
    // shelf.debug._initQueryExecutionUnitsCount++;
    // //
    // executionTrace._addTraceStep(
    //   codeId: "#01000",
    //   shortDesc: toDebugXShelfStateAsHtml(),
    //   traceStepType: TraceStepType.debug,
    // );
    // //
    // final executionUnit = _ShelfStarterExecutionUnit(
    //   xShelf: this,
    // );
    // executionTrace._addTraceStep(
    //   codeId: "#01060",
    //   shortDesc:
    //       "Create ${executionUnit.asDebugExecutionUnit()} and add to ${debugObjHtml(this)}.",
    //   traceStepType: TraceStepType.addExecutionUnit,
    // );
    // //
    // _addExecutionUnit(
    //   executionUnit: executionUnit,
    //   toMainQueue: true,
    // );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  // String toDebugXShelfStateAsHtml() {
  //   String s = "${debugObjHtml(this)}\n"
  //       " --- STATE BEFORE CREATING EXECUTION UNITS ---";
  //   for (String key in xBlockMap.keys) {
  //     final XBlock xBlock = xBlockMap[key]!;
  //     s += "\n${xBlock.toDebugHtmlString()}";
  //   }
  //   for (String key in xScalarMap.keys) {
  //     final XScalar xScalar = xScalarMap[key]!;
  //     s += "\n${xScalar.toDebugHtmlString()}";
  //   }
  //   return s;
  // }

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
