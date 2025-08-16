part of '../core.dart';

int __qShelfIdSequence = 0;

enum QShelfType {
  naturalQuery,
  blockQuery,
  blockQueryEmpty,
  blockQueryAndPrepareToCreate,
  blockPrepareFormToCreateItem,
  blockCurrItemClearance,
  blockClearance,
  blockItemDeletion,
  blockMultiItemsDeletion,
  blockCurrItemSelection,
  blockQuickActionExecution,
  blockQuickItemCreation,
  blockQuickItemUpdate,
  blockQuickMultiItemsCreation,
  @Deprecated("Xoa di")
  blockQuickChildBlockItemsAction,
  //
  filterModelQueryAll,
  formModelSave,
  //
  scalarQuery,
  scalarQuickAction,
  scalarQuickExtraDataLoadAction;
}

class _QShelf {
  final QShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  final Map<String, _QFilterModel> xFilterModelMap = {};
  final Map<String, _QFormModel> xFormModelMap = {};
  final Map<String, _QScalar> xScalarMap = {};
  final Map<String, _QBlock> xBlockMap = {};

  final List<_QBlock> allRootXBlocks = [];
  final List<_QBlock> allLeafXBlocks = [];
  final List<_QScalar> allXScalars = [];
  final List<_QBlock> allXBlocks = [];
  final List<_QFilterModel> allXFilterModels = [];
  final List<_QFormModel> allXFormModels = [];

  bool get naturalMode => xShelfType == QShelfType.naturalQuery;

  bool isNothingTodo() {
    for (_QBlock rootXBlock in allRootXBlocks) {
      if (rootXBlock.hasQryHintInTreeBranchAndNotProcessed()) {
        return false;
      }
    }
    for (_QScalar xScalar in allXScalars) {
      if (xScalar.needQuery) {
        return false;
      }
    }
    return true;
  }

  // ***************************************************************************

  // This method will be called in all constructors to init an empty XShelf.
  void __initCore({required Shelf shelf}) {
    xShelfId = __qShelfIdSequence++;
    //
    for (FilterModel filterModel in shelf._allFilterModels) {
      final xFilterModel = _QFilterModel(
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
      final xScalar = _QScalar(
        scalar: scalar,
        xFilterModel: xFilterModel,
      );
      xFilterModel.xScalars.add(xScalar);
      allXScalars.add(xScalar);
      xScalarMap[scalar.name] = xScalar;
    }
    for (Block block in shelf.blocks) {
      final FormModel? formModel = block.formModel;
      _QFormModel? xFormModel;
      if (formModel != null) {
        xFormModel = _QFormModel(formModel: formModel, extraFormInput: null);
        allXFormModels.add(xFormModel);
        xFormModelMap[formModel.block.name] = xFormModel;
      }
      //
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      final xBlock = _QBlock(
        block: block,
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
      _QBlock xBlock = xBlockMap[block.name]!;
      Block? parent = block.parent;
      if (parent != null) {
        _QBlock xBlockParent = xBlockMap[parent.name]!;
        xBlock.parentXBlock = xBlockParent;
        xBlockParent.childXBlocks.add(xBlock);
      } else {
        xBlock.parentXBlock = null;
      }
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forNaturalQuery({required this.shelf})
      : xShelfType = QShelfType.naturalQuery {
    __initCore(shelf: shelf);
    //
    for (_QScalar xScalar in allXScalars) {
      if (xScalar.scalar.ui.hasActiveUIComponent()) {
        if (xScalar.scalar.queryDataState == DataState.pending ||
            xScalar.scalar.queryDataState == DataState.error) {
          xScalar.setForceQuery();
        }
      }
    }
    //
    for (_QBlock leafXBlock in allLeafXBlocks) {
      _QBlock? xBlock = leafXBlock;
      while (true) {
        if (xBlock == null) {
          break;
        }
        bool hasXActiveUI = xBlock.block.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (xBlock.block.queryDataState == DataState.pending ||
              xBlock.block.queryDataState == DataState.error) {
            xBlock.setForceQuery(QryHint.force);
          }
        }
        _QFormModel? xFormModel = xBlock.xFormModel;
        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.formDataState == DataState.pending ||
              xFormModel.formModel.formDataState == DataState.error ||
              xFormModel.formModel.formDataState == DataState.none) {
            xFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQuery({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = QShelfType.blockQuery,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    if (forceReloadItem) {
      thisXBlock.setForceReloadItem();
    }
    //
    thisXBlock.setForceQuery(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _QBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.queryDataState == DataState.pending ||
            parentXBlock.block.queryDataState == DataState.error) {
          parentXBlock.setForceQuery(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      _QFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.formDataState == DataState.pending ||
            parentXFormModel.formModel.formDataState == DataState.error ||
            parentXFormModel.formModel.formDataState == DataState.none) {
          parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQueryEmpty({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = QShelfType.blockQueryEmpty,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    if (forceReloadItem) {
      thisXBlock.setForceReloadItem();
    }
    //
    thisXBlock.setForceQuery(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.emptyQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _QBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.queryDataState == DataState.pending ||
            parentXBlock.block.queryDataState == DataState.error) {
          parentXBlock.setForceQuery(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      _QFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.formDataState == DataState.pending ||
            parentXFormModel.formModel.formDataState == DataState.error ||
            parentXFormModel.formModel.formDataState == DataState.none) {
          parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQueryAndPrepareToCreate({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = QShelfType.blockQueryAndPrepareToCreate,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    if (forceReloadItem) {
      thisXBlock.setForceReloadItem();
    }
    //
    thisXBlock.setForceQuery(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _QBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.queryDataState == DataState.pending ||
            parentXBlock.block.queryDataState == DataState.error) {
          parentXBlock.setForceQuery(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      _QFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.formDataState == DataState.pending ||
            parentXFormModel.formModel.formDataState == DataState.error ||
            parentXFormModel.formModel.formDataState == DataState.none) {
          parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQueryAndPrepareToEdit({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = QShelfType.blockQueryAndPrepareToCreate,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    if (forceReloadItem) {
      thisXBlock.setForceReloadItem();
    }
    //
    thisXBlock.setForceQuery(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _QBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.queryDataState == DataState.pending ||
            parentXBlock.block.queryDataState == DataState.error) {
          parentXBlock.setForceQuery(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      _QFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.formDataState == DataState.pending ||
            parentXFormModel.formModel.formDataState == DataState.error ||
            parentXFormModel.formModel.formDataState == DataState.none) {
          parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forFilterModelQueryAll({
    required FilterModel filterModel,
    required FilterInput? filterInput,
  })  : xShelfType = QShelfType.filterModelQueryAll,
        shelf = filterModel.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel.filterInput = filterInput;
    //
    for (_QBlock xBlock in thisXFilterModel.xBlocks) {
      xBlock.setForceQuery(queryHint);
      xBlock.setOptions(
        queryType: QueryType.realQuery,
        listBehavior: ListBehavior.replace,
        suggestedSelection: null,
        postQueryBehavior: null,
        pageable: null,
      );
      //
      _QBlock? parentXBlock = xBlock.parentXBlock;
      while (true) {
        if (parentXBlock == null) {
          break;
        }
        //
        final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (parentXBlock.block.queryDataState == DataState.pending ||
              parentXBlock.block.queryDataState == DataState.error) {
            parentXBlock.setForceQuery(QryHint.force);
          }
        }
        // TODO: Need? Remove this code?
        _QFormModel? parentXFormModel = parentXBlock.xFormModel;
        if (parentXFormModel != null &&
            parentXFormModel.formModel.ui.hasActiveUIComponent()) {
          if (parentXFormModel.formModel.formDataState == DataState.pending ||
              parentXFormModel.formModel.formDataState == DataState.error ||
              parentXFormModel.formModel.formDataState == DataState.none) {
            parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
          }
        }
        //
        parentXBlock = parentXBlock.parentXBlock;
      }
    }
    for (_QScalar xScalar in thisXFilterModel.xScalars) {
      xScalar.setForceQuery();
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forFormModelSave({required FormModel formModel})
      : xShelfType = QShelfType.formModelSave,
        shelf = formModel.block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forPrepareFormToCreateItem({required Block block})
      : xShelfType = QShelfType.blockPrepareFormToCreateItem,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockClearCurrentItem({required Block block})
      : xShelfType = QShelfType.blockCurrItemClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockClearance({required Block block})
      : xShelfType = QShelfType.blockClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockItemDeletion({required Block block})
      : xShelfType = QShelfType.blockItemDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockMultiItemsDeletion({required Block block})
      : xShelfType = QShelfType.blockMultiItemsDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockCurrItemSelection({required Block block})
      : xShelfType = QShelfType.blockCurrItemSelection,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQuickActionExecution({
    required Block block,
    required FilterInput? filterInput,
    required AfterBlockQuickAction afterQuickAction,
  })  : xShelfType = QShelfType.blockQuickActionExecution,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    QryHint queryHint = QryHint.none;
    bool forceReloadItem = false;
    //
    final thisXBlock = xBlockMap[block.name]!;
    final xFilterModel = thisXBlock.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    switch (afterQuickAction) {
      case AfterBlockQuickAction.none:
        break;
      case AfterBlockQuickAction.refreshCurrentItem:
        break;
      case AfterBlockQuickAction.query:
        queryHint = QryHint.force;
        forceReloadItem = false;
    }
    //
    thisXBlock.setForceQuery(queryHint);
    if (forceReloadItem) {
      thisXBlock.setForceReloadItem();
    }
    //
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: null,
      suggestedSelection: null,
      postQueryBehavior: null,
      pageable: null,
    );
    _QBlock? parentXBlock = thisXBlock.parentXBlock;
    while (true) {
      if (parentXBlock == null) {
        break;
      }
      //
      final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragmentWidget(
        alsoCheckChildren: true,
      );
      if (hasXActiveUI) {
        if (parentXBlock.block.queryDataState == DataState.pending ||
            parentXBlock.block.queryDataState == DataState.error) {
          parentXBlock.setForceQuery(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      _QFormModel? parentXFormModel = parentXBlock.xFormModel;
      if (parentXFormModel != null &&
          parentXFormModel.formModel.ui.hasActiveUIComponent()) {
        if (parentXFormModel.formModel.formDataState == DataState.pending ||
            parentXFormModel.formModel.formDataState == DataState.error ||
            parentXFormModel.formModel.formDataState == DataState.none) {
          parentXFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
        }
      }
      //
      parentXBlock = parentXBlock.parentXBlock;
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQuickItemCreation({required Block block})
      : xShelfType = QShelfType.blockQuickItemCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQuickItemUpdate({required Block block})
      : xShelfType = QShelfType.blockQuickItemUpdate,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forBlockQuickMultiItemsCreation({required Block block})
      : xShelfType = QShelfType.blockQuickMultiItemsCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  @Deprecated("Xoa di")
  _QShelf.forQuickChildBlockItemsAction({required Block block})
      : xShelfType = QShelfType.blockQuickChildBlockItemsAction,
        shelf = block.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forScalarQuery({
    required Scalar scalar,
    required FilterInput? filterInput,
  })  : xShelfType = QShelfType.scalarQuery,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    // bool forceQuery = false;
    // switch (afterQuickAction) {
    //   case AfterScalarQuickAction.none:
    //     forceQuery = false;
    //   case AfterScalarQuickAction.query:
    //     forceQuery = true;
    // }
    // //
    // if (forceQuery) {
    //   thisXScalar.setForceQuery();
    // }
    thisXScalar.setForceQuery();
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forScalarQuickAction({
    required Scalar scalar,
  })  : xShelfType = QShelfType.scalarQuickAction,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    // final thisXScalar = xScalarMap[scalar.name]!;
    // final xFilterModel = thisXScalar.xFilterModel;
    // xFilterModel.filterInput = filterInput;
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _QShelf.forScalarQuickExtraDataLoadAction({
    required Scalar scalar,
    required FilterInput? filterInput,
  })  : xShelfType = QShelfType.scalarQuickExtraDataLoadAction,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXScalar.setForceQuery();
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void printMe() {
    print("\nXShelf BEFORE QUERY:");
    for (String key in xBlockMap.keys) {
      print(" --> XShelf/Block: $key - ${xBlockMap[key]}");
    }
    for (String key in xScalarMap.keys) {
      print(" --> XShelf/Scalar: $key - ${xScalarMap[key]}");
    }
    for (_QFormModel xFormModel in allXFormModels) {
      print(" --> XShelf/FormModel: ${xFormModel.xBlock.name} - $xFormModel");
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  _QFilterModel? findXFilterModelByName(String name) {
    return xFilterModelMap[name];
  }

  _QBlock? findXBlockByName(String name) {
    return xBlockMap[name];
  }

  _QScalar? findXScalarByName(String name) {
    return xScalarMap[name];
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  _QScalar? nextXScalarTask() {
    for (_QScalar xScalar in allXScalars) {
      if (!xScalar.needQuery) {
        continue;
      }
      if (!xScalar._processed) {
        return xScalar;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  _QBlock? nextRootXBlockTask() {
    for (_QBlock xBlock in allRootXBlocks) {
      if (xBlock.hasQryHintInTreeBranchAndNotProcessed()) {
        return xBlock;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    for (_QScalar xScalar in allXScalars) {
      if (xScalar.needQuery) {
        xScalar.printInfo();
      }
    }
    for (_QBlock xBlock in allRootXBlocks) {
      xBlock.printInfoCascade();
    }
  }
}
