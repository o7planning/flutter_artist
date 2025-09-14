part of '../core.dart';

int __xShelfSequence = 0;

abstract class XShelf {
  final XShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  late final __xShelfTaskUnitQueue = _XShelfTaskUnitQueue(xShelf: this);

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

  XBlock? __rootVipXBlock;

  XBlock? get rootVipXBlock => __rootVipXBlock;

  XScalar? __rootVipXScalar;

  XScalar? get rootVipXScalar => __rootVipXScalar;

  bool get naturalMode => xShelfType == XShelfType.naturalQuery;

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  XShelf({required this.xShelfType, required this.shelf})
      : xShelfId = __xShelfSequence++ {
    for (FilterModel filterModel in shelf._allFilterModels) {
      final xFilterModel = XFilterModel(
        xShelf: this,
        filterModel: filterModel,
      );
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
        xFormModel = formModel._createXFormModel(extraFormInput: null);
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
      if (xBlock.queryHint != QryHint.none) {
        ret.addLazyBlock(
          block: xBlock.block,
          queryHint: xBlock.queryHint,
        );
      }
    }
    for (XScalar xScalar in allXScalars) {
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
  void _updateInternalReactionByEvtBlock({required XBlock eventXBlock}) {
    __assertXShelf(eventXBlock.xShelf);
    //
    if (__rootVipXBlock != eventXBlock.rootXBlock) {
      throw "Development Logic Error";
    }

    __printXShelfInfo(
      message: "XSHELF BEFORE INTERNAL UPDATE",
      xShelf: eventXBlock.xShelf,
    );

    final EffectedShelfMembers effectedShelfMembers =
        eventXBlock.block._internalEffectedShelfMembers;

    print("\n**************************************************************");
    print(" --- INTERNAL EVENT (EFFECTED SHELF MEMBER) --- ");
    effectedShelfMembers.printInfo();
    print("**************************************************************\n");

    //
    Set<String> listenerBlockNames = {}
      ..addAll(effectedShelfMembers._reQueryBlockMAP.keys)
      ..addAll(effectedShelfMembers._refreshCurrItmBlockMAP.keys);

    for (String listenerBlkName in listenerBlockNames) {
      final Block? reQryBlock =
          effectedShelfMembers._reQueryBlockMAP[listenerBlkName];
      final Block? refreshCurrBlock =
          effectedShelfMembers._refreshCurrItmBlockMAP[listenerBlkName];
      //
      bool blockVisible = false;
      QryHint queryHint = QryHint.none;
      bool forceReloadCurrItem = false;
      //
      if (reQryBlock != null) {
        blockVisible = reQryBlock.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        queryHint = blockVisible ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        blockVisible = refreshCurrBlock.ui.hasActiveBlockFragment(
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
    for (Scalar s in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = s.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool hasActiveUI = s.ui.hasActiveUIComponent();
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
        bool hasXActiveUI = xBlock.block.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (xBlock.block.dataState == DataState.pending ||
              xBlock.block.dataState == DataState.error) {
            xBlock.setQueryHintToGreater(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;

        // Current: updateInternalReactionByEvtBlock.
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.dataState == DataState.pending ||
              xFormModel.formModel.dataState == DataState.error ||
              xFormModel.formModel.dataState == DataState.none) {
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
    __printXShelfInfo(
      message: "XSHELF AFTER INTERNAL UPDATE",
      xShelf: eventXBlock.xShelf,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __printXShelfInfo({required String message, required XShelf xShelf}) {
    print("\n**************************************************************");
    print(" -- $message --");
    xShelf.printInfo();
    print("**************************************************************\n");
  }

  void _initQueryTasks() {
    if (rootVipXScalar != null && rootVipXBlock != null) {
      throw "Development Logic Error";
    }
    shelf._debugInitQueryTasksCount++;
    printMe();
    final bool toMainQueue = false;
    //
    if (rootVipXScalar != null) {
      //
      // Execute vipXScalar first!!
      //
      _addTaskUnit(
        taskUnit: _ScalarQueryTaskUnit(
          xScalar: rootVipXScalar!,
        ),
        toMainQueue: toMainQueue,
      );
    } else if (rootVipXBlock != null) {
      //
      // Execute rootVipXBlock first!!
      //
      _addTaskUnit(
        taskUnit: _BlockQueryTaskUnit(
          xBlock: rootVipXBlock!,
        ),
        toMainQueue: toMainQueue,
      );
    }
    //
    for (XScalar xScalar in allRootXScalars) {
      if (xScalar != rootVipXScalar) {
        _addTaskUnit(
          taskUnit: _ScalarQueryTaskUnit(
            xScalar: xScalar,
          ),
          toMainQueue: toMainQueue,
        );
      }
    }
    //
    for (XBlock rootXBlock in allRootXBlocks) {
      if (rootXBlock != rootVipXBlock) {
        _addTaskUnit(
          taskUnit: _BlockQueryTaskUnit(
            xBlock: rootXBlock,
          ),
          toMainQueue: toMainQueue,
        );
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void printMe() {
    print("\nXShelf BEFORE QUERY [${xShelfType.name}]:");
    for (String key in xBlockMap.keys) {
      print(" --> XShelf/Block: $key - ${xBlockMap[key]}");
    }
    for (String key in xScalarMap.keys) {
      print(" --> XShelf/Scalar: $key - ${xScalarMap[key]}");
    }
    for (XFormModel xFormModel in allXFormModels) {
      print(" --> XShelf/FormModel: ${xFormModel.xBlock.name} - $xFormModel");
    }
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

  XScalar? nextXScalarTask() {
    for (XScalar xScalar in allXScalars) {
      if (xScalar.queryHint == QryHint.none) {
        continue;
      }
      return xScalar;
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  XBlock? nextRootXBlockTask() {
    for (XBlock xBlock in allRootXBlocks) {
      if (xBlock.hasQryHintInTreeBranchAndNotProcessed()) {
        return xBlock;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  DebugXShelfTaskUnitQueue toDebugXShelfTaskUnitQueue() {
    return __xShelfTaskUnitQueue.toDebugXShelfTaskUnitQueue();
  }

  bool isEmptyTask() {
    return __xShelfTaskUnitQueue.isEmpty;
  }

  _STaskUnit? _getNextTaskUnit() {
    return __xShelfTaskUnitQueue.getNextTaskUnit();
  }

  void _addTaskUnit({required _STaskUnit taskUnit, bool toMainQueue = true}) {
    if (taskUnit.xShelf != this) {
      throw FatalAppError(
        errorMessage: "Development Logic Error.",
      );
    }
    __xShelfTaskUnitQueue.addTaskUnit(
      taskUnit: taskUnit,
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
