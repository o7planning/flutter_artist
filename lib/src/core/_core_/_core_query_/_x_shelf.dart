part of '../core.dart';

int __xShelfSequence = 0;

class XShelf {
  final XShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  final Map<String, XFilterModel> xFilterModelMap = {};
  final Map<String, XFormModel> xFormModelMap = {};
  final Map<String, XScalar> xScalarMap = {};
  final Map<String, XBlock> xBlockMap = {};

  final List<XBlock> allRootXBlocks = [];
  final List<XBlock> allLeafXBlocks = [];
  final List<XScalar> allXScalars = [];
  final List<XBlock> allXBlocks = [];
  final List<XFilterModel> allXFilterModels = [];
  final List<XFormModel> allXFormModels = [];

  XBlock? __rootVipXBlock;

  XBlock? get rootVipXBlock => __rootVipXBlock;

  XScalar? __vipXScalar;

  XScalar? get vipXScalar => __vipXScalar;

  bool get naturalMode => xShelfType == XShelfType.naturalQuery;

  // ***************************************************************************

  void setRootVipXBlock({required XBlock descendantXBlock}) {
    __rootVipXBlock = descendantXBlock.rootXBlock;
  }

  void setVipXScalar({required XScalar xScalar}) {
    __vipXScalar = xScalar;
  }

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

  // This method will be called in all constructors to init an empty XShelf.
  void __initCore({required Shelf shelf}) {
    xShelfId = __xShelfSequence++;
    //
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
      final xScalar = XScalar(
        scalar: scalar,
        xFilterModel: xFilterModel,
      );
      xFilterModel.xScalars.add(xScalar);
      allXScalars.add(xScalar);
      xScalarMap[scalar.name] = xScalar;
    }
    for (Block block in shelf.blocks) {
      final FormModel? formModel = block.formModel;
      XFormModel? xFormModel;
      if (formModel != null) {
        xFormModel = XFormModel(formModel: formModel, extraFormInput: null);
        allXFormModels.add(xFormModel);
        xFormModelMap[formModel.block.name] = xFormModel;
      }
      //
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      final xBlock = XBlock(
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
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forNaturalQuery({required this.shelf})
      : xShelfType = XShelfType.naturalQuery {
    __initCore(shelf: shelf);
    //
    for (XScalar xScalar in allXScalars) {
      if (xScalar.scalar.ui.hasActiveUIComponent()) {
        if (xScalar.scalar.queryDataState == DataState.pending ||
            xScalar.scalar.queryDataState == DataState.error) {
          xScalar.setQueryHint(QryHint.force);
        }
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
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
            xBlock.setQueryHint(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;

        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.formDataState == DataState.pending ||
              xFormModel.formModel.formDataState == DataState.error ||
              xFormModel.formModel.formDataState == DataState.none) {
            xFormModel.lazy = true;
            if (naturalMode) {
              xFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
            } else {
              xFormModel.forceTypeForForm = ForceType.force;
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forShelfExternalReaction({
    required this.shelf,
    required EffectedShelfMembers effectedShelfMembers,
  }) : xShelfType = XShelfType.shelfExternalReaction {
    __initCore(shelf: shelf);
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
      bool forceReloadItem = false;
      //
      if (reQryBlock != null) {
        blockVisible = reQryBlock.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        queryHint = blockVisible ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        blockVisible = refreshCurrBlock.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        forceReloadItem = true;
      }
      //
      XBlock xBlock = xBlockMap[listenerBlkName]!;
      xBlock.setQueryHint(queryHint);
      xBlock.setForceReloadCurrItem(forceReloadItem);
    }
    //
    for (Scalar s in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = s.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool hasActiveUI = s.ui.hasActiveUIComponent();
      if (hasActiveUI) {
        // Test Cases: [84a].
        xScalar.setQueryHint(QryHint.force);
      } else {
        // Test Cases: [84b].
        xScalar.setQueryHint(QryHint.markAsPending);
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
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
            xBlock.setQueryHint(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;

        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.formDataState == DataState.pending ||
              xFormModel.formModel.formDataState == DataState.error ||
              xFormModel.formModel.formDataState == DataState.none) {
            xFormModel.lazy = true;
            if (naturalMode) {
              xFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
            } else {
              xFormModel.forceTypeForForm = ForceType.force;
            }
          }
        }
        xBlock = xBlock.parentXBlock;
      }
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQuery({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = XShelfType.blockQuery,
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
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    //
    XBlock? parentXBlock = thisXBlock.parentXBlock;
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
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQueryEmpty({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = XShelfType.blockQueryEmpty,
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
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.emptyQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    XBlock? parentXBlock = thisXBlock.parentXBlock;
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
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQueryAndPrepareToCreate({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = XShelfType.blockQueryAndPrepareToCreate,
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
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    //
    XBlock? parentXBlock = thisXBlock.parentXBlock;
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
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQueryAndPrepareToEdit({
    required Block block,
    required FilterInput? filterInput,
    required PageableData? pageable,
    required ListBehavior? listBehavior,
    required PostQueryBehavior? postQueryBehavior,
    required SuggestedSelection<dynamic>? suggestedSelection,
  })  : xShelfType = XShelfType.blockQueryAndPrepareToCreate,
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
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    XBlock? parentXBlock = thisXBlock.parentXBlock;
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
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    // IMPORTANT:
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forFilterModelQueryAll({
    required FilterModel filterModel,
    required FilterInput? filterInput,
  })  : xShelfType = XShelfType.filterModelQueryAll,
        shelf = filterModel.shelf {
    __initCore(shelf: shelf);
    //
    final queryHint = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel.filterInput = filterInput;
    //
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      xBlock.setQueryHint(queryHint);
      xBlock.setOptions(
        queryType: QueryType.realQuery,
        listBehavior: ListBehavior.replace,
        suggestedSelection: null,
        postQueryBehavior: null,
        pageable: null,
      );
      //
      XBlock? parentXBlock = xBlock.parentXBlock;
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
            parentXBlock.setQueryHint(QryHint.force);
          }
        }
        // TODO: Need? Remove this code?
        XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    for (XScalar xScalar in thisXFilterModel.xScalars) {
      xScalar.setQueryHint(QryHint.force);
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forFormModelSave({required FormModel formModel})
      : xShelfType = XShelfType.formModelSave,
        shelf = formModel.block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forFormModelEnterFields({required FormModel formModel})
      : xShelfType = XShelfType.formModelEnterFields,
        shelf = formModel.block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forPrepareFormToCreateItem({required Block block})
      : xShelfType = XShelfType.blockPrepareFormToCreateItem,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockClearCurrentItem({required Block block})
      : xShelfType = XShelfType.blockCurrItemClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockClearance({required Block block})
      : xShelfType = XShelfType.blockClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockItemDeletion({required Block block})
      : xShelfType = XShelfType.blockItemDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockMultiItemsDeletion({required Block block})
      : xShelfType = XShelfType.blockMultiItemsDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockCurrItemSelection({required Block block})
      : xShelfType = XShelfType.blockCurrItemSelection,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQuickActionExecution({
    required Block block,
    required FilterInput? filterInput,
    required AfterBlockQuickAction afterQuickAction,
  })  : xShelfType = XShelfType.blockQuickActionExecution,
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
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setForceReloadCurrItem(forceReloadItem);
    //
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: null,
      suggestedSelection: null,
      postQueryBehavior: null,
      pageable: null,
    );
    //
    XBlock? parentXBlock = thisXBlock.parentXBlock;
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
          parentXBlock.setQueryHint(QryHint.force);
        }
      }
      // TODO: Need? Remove this code?
      XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQuickItemCreation({required Block block})
      : xShelfType = XShelfType.blockQuickItemCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQuickItemUpdate({required Block block})
      : xShelfType = XShelfType.blockQuickItemUpdate,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forBlockQuickMultiItemsCreation({required Block block})
      : xShelfType = XShelfType.blockQuickMultiItemsCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  @Deprecated("Xoa di")
  XShelf.forQuickChildBlockItemsAction({required Block block})
      : xShelfType = XShelfType.blockQuickChildBlockItemsAction,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forFormViewChange({required FormModel formModel})
      : xShelfType = XShelfType.formViewChange,
        shelf = formModel.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forFilterViewChange({required FilterModel filterModel})
      : xShelfType = XShelfType.filterViewChange,
        shelf = filterModel.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************
  XShelf.forScalarQuery({
    required Scalar scalar,
    required FilterInput? filterInput,
  })  : xShelfType = XShelfType.scalarQuery,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXScalar.setQueryHint(QryHint.force);
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forScalarQuickAction({
    required Scalar scalar,
  })  : xShelfType = XShelfType.scalarQuickAction,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  XShelf.forScalarQuickExtraDataLoadAction({
    required Scalar scalar,
    required FilterInput? filterInput,
  })  : xShelfType = XShelfType.scalarQuickExtraDataLoadAction,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    final thisXScalar = xScalarMap[scalar.name]!;
    final xFilterModel = thisXScalar.xFilterModel;
    xFilterModel.filterInput = filterInput;
    //
    thisXScalar.setQueryHint(QryHint.force);
    //
    // IMPORTANT:
    //
    XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  //
  // IMPORTANT: Sync Method.
  //
  void updateInternalReactionByEvtBlock({required XBlock eventXBlock}) {
    __assertXShelf(eventXBlock.xShelf);
    //
    if (__rootVipXBlock != eventXBlock.rootXBlock) {
      throw "Development Logic Error";
    }
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> Chay vao day 1");
    final EffectedShelfMembers effectedShelfMembers =
        eventXBlock.block._internalEffectedShelfMembers;

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
      bool forceReloadItem = false;
      //
      if (reQryBlock != null) {
        blockVisible = reQryBlock.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        queryHint = blockVisible ? QryHint.force : QryHint.markAsPending;
      }
      if (refreshCurrBlock != null) {
        blockVisible = refreshCurrBlock.ui.hasActiveBlockFragmentWidget(
          alsoCheckChildren: true,
        );
        forceReloadItem = true;
      }
      //
      XBlock xBlock = xBlockMap[listenerBlkName]!;
      xBlock.setQueryHint(queryHint);
      xBlock.setForceReloadCurrItem(forceReloadItem);
    }
    //
    for (Scalar s in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = s.name;
      XScalar xScalar = xScalarMap[scalarName]!;
      //
      bool hasActiveUI = s.ui.hasActiveUIComponent();
      if (hasActiveUI) {
        //
        xScalar.setQueryHint(QryHint.force);
      } else {
        //
        xScalar.setQueryHint(QryHint.markAsPending);
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
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
            xBlock.setQueryHint(QryHint.force);
          }
        }
        XFormModel? xFormModel = xBlock.xFormModel;

        if (xFormModel != null &&
            xFormModel.formModel.ui.hasActiveUIComponent()) {
          if (xFormModel.formModel.formDataState == DataState.pending ||
              xFormModel.formModel.formDataState == DataState.error ||
              xFormModel.formModel.formDataState == DataState.none) {
            xFormModel.lazy = true;
            if (naturalMode) {
              xFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
            } else {
              xFormModel.forceTypeForForm = ForceType.force;
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
      if (!xScalar._processed) {
        return xScalar;
      }
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
