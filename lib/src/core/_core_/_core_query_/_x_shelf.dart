part of '../core.dart';

int __xShelfSequence = 0;

class _XShelf {
  final XShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  final Map<String, _XFilterModel> xFilterModelMap = {};
  final Map<String, _XFormModel> xFormModelMap = {};
  final Map<String, _XScalar> xScalarMap = {};
  final Map<String, _XBlock> xBlockMap = {};

  final List<_XBlock> allRootXBlocks = [];
  final List<_XBlock> allLeafXBlocks = [];
  final List<_XScalar> allXScalars = [];
  final List<_XBlock> allXBlocks = [];
  final List<_XFilterModel> allXFilterModels = [];
  final List<_XFormModel> allXFormModels = [];

  _XBlock? __rootVipXBlock;

  _XBlock? get rootVipXBlock => __rootVipXBlock;

  _XScalar? __vipXScalar;

  _XScalar? get vipXScalar => __vipXScalar;

  bool get naturalMode => xShelfType == XShelfType.naturalQuery;

  // ***************************************************************************

  void setRootVipXBlock({required _XBlock descendantXBlock}) {
    __rootVipXBlock = descendantXBlock.rootXBlock;
  }

  void setVipXScalar({required _XScalar xScalar}) {
    __vipXScalar = xScalar;
  }

  // ***************************************************************************

  _LazyObjects getLazyObjectInfos() {
    final _LazyObjects ret = _LazyObjects();
    for (_XBlock xBlock in allXBlocks) {
      if (xBlock.queryHint != QryHint.none) {
        ret.addLazyBlock(
          block: xBlock.block,
          queryHint: xBlock.queryHint,
        );
      }
    }
    for (_XScalar xScalar in allXScalars) {
      if (xScalar.queryHint != QryHint.none) {
        ret.addLazyScalar(scalar: xScalar.scalar);
      }
    }
    for (_XFormModel xFormModel in allXFormModels) {
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
      final xFilterModel = _XFilterModel(
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
      final xScalar = _XScalar(
        scalar: scalar,
        xFilterModel: xFilterModel,
      );
      xFilterModel.xScalars.add(xScalar);
      allXScalars.add(xScalar);
      xScalarMap[scalar.name] = xScalar;
    }
    for (Block block in shelf.blocks) {
      final FormModel? formModel = block.formModel;
      _XFormModel? xFormModel;
      if (formModel != null) {
        xFormModel = _XFormModel(formModel: formModel, extraFormInput: null);
        allXFormModels.add(xFormModel);
        xFormModelMap[formModel.block.name] = xFormModel;
      }
      //
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      final xBlock = _XBlock(
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
      _XBlock xBlock = xBlockMap[block.name]!;
      Block? parent = block.parent;
      if (parent != null) {
        _XBlock xBlockParent = xBlockMap[parent.name]!;
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

  _XShelf.forNaturalQuery({required this.shelf})
      : xShelfType = XShelfType.naturalQuery {
    __initCore(shelf: shelf);
    //
    for (_XScalar xScalar in allXScalars) {
      if (xScalar.scalar.ui.hasActiveUIComponent()) {
        if (xScalar.scalar.queryDataState == DataState.pending ||
            xScalar.scalar.queryDataState == DataState.error) {
          xScalar.setQueryHint(QryHint.force);
        }
      }
    }
    //
    for (_XBlock leafXBlock in allLeafXBlocks) {
      _XBlock? xBlock = leafXBlock;
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
        _XFormModel? xFormModel = xBlock.xFormModel;

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

  _XShelf.forShelfExternalReaction({
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
      _XBlock xBlock = xBlockMap[listenerBlkName]!;
      xBlock.setQueryHint(queryHint);
      xBlock.setForceReloadItem(forceReloadItem);
    }
    //
    for (Scalar s in effectedShelfMembers._reQueryScalarMAP.values) {
      String scalarName = s.name;
      _XScalar xScalar = xScalarMap[scalarName]!;
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
    for (_XBlock leafXBlock in allLeafXBlocks) {
      _XBlock? xBlock = leafXBlock;
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
        _XFormModel? xFormModel = xBlock.xFormModel;

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

  _XShelf.forBlockQuery({
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
    thisXBlock.setForceReloadItem(forceReloadItem);
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
    _XBlock? parentXBlock = thisXBlock.parentXBlock;
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
      _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQueryEmpty({
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
    thisXBlock.setForceReloadItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.emptyQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _XBlock? parentXBlock = thisXBlock.parentXBlock;
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
      _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQueryAndPrepareToCreate({
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
    thisXBlock.setForceReloadItem(forceReloadItem);
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
    _XBlock? parentXBlock = thisXBlock.parentXBlock;
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
      _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQueryAndPrepareToEdit({
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
    thisXBlock.setForceReloadItem(forceReloadItem);
    //
    thisXBlock.setQueryHint(queryHint);
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: listBehavior,
      suggestedSelection: suggestedSelection,
      postQueryBehavior: postQueryBehavior,
      pageable: pageable,
    );
    _XBlock? parentXBlock = thisXBlock.parentXBlock;
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
      _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forFilterModelQueryAll({
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
    for (_XBlock xBlock in thisXFilterModel.xBlocks) {
      xBlock.setQueryHint(queryHint);
      xBlock.setOptions(
        queryType: QueryType.realQuery,
        listBehavior: ListBehavior.replace,
        suggestedSelection: null,
        postQueryBehavior: null,
        pageable: null,
      );
      //
      _XBlock? parentXBlock = xBlock.parentXBlock;
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
        _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    for (_XScalar xScalar in thisXFilterModel.xScalars) {
      xScalar.setQueryHint(QryHint.force);
    }
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forFormModelSave({required FormModel formModel})
      : xShelfType = XShelfType.formModelSave,
        shelf = formModel.block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forFormModelEnterFields({required FormModel formModel})
      : xShelfType = XShelfType.formModelEnterFields,
        shelf = formModel.block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forPrepareFormToCreateItem({required Block block})
      : xShelfType = XShelfType.blockPrepareFormToCreateItem,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockClearCurrentItem({required Block block})
      : xShelfType = XShelfType.blockCurrItemClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockClearance({required Block block})
      : xShelfType = XShelfType.blockClearance,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockItemDeletion({required Block block})
      : xShelfType = XShelfType.blockItemDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockMultiItemsDeletion({required Block block})
      : xShelfType = XShelfType.blockMultiItemsDeletion,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockCurrItemSelection({required Block block})
      : xShelfType = XShelfType.blockCurrItemSelection,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQuickActionExecution({
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
    thisXBlock.setForceReloadItem(forceReloadItem);
    //
    thisXBlock.setOptions(
      queryType: QueryType.realQuery,
      listBehavior: null,
      suggestedSelection: null,
      postQueryBehavior: null,
      pageable: null,
    );
    //
    _XBlock? parentXBlock = thisXBlock.parentXBlock;
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
      _XFormModel? parentXFormModel = parentXBlock.xFormModel;
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
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQuickItemCreation({required Block block})
      : xShelfType = XShelfType.blockQuickItemCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQuickItemUpdate({required Block block})
      : xShelfType = XShelfType.blockQuickItemUpdate,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forBlockQuickMultiItemsCreation({required Block block})
      : xShelfType = XShelfType.blockQuickMultiItemsCreation,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  @Deprecated("Xoa di")
  _XShelf.forQuickChildBlockItemsAction({required Block block})
      : xShelfType = XShelfType.blockQuickChildBlockItemsAction,
        shelf = block.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forFormViewChange({required FormModel formModel})
      : xShelfType = XShelfType.formViewChange,
        shelf = formModel.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XBlock xBlock = xBlockMap[formModel.block.name]!;
    setRootVipXBlock(descendantXBlock: xBlock);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forFilterViewChange({required FilterModel filterModel})
      : xShelfType = XShelfType.filterViewChange,
        shelf = filterModel.shelf {
    __initCore(shelf: shelf);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************
  _XShelf.forScalarQuery({
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
    _XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forScalarQuickAction({
    required Scalar scalar,
  })  : xShelfType = XShelfType.scalarQuickAction,
        shelf = scalar.shelf {
    __initCore(shelf: shelf);
    //
    // IMPORTANT:
    //
    _XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
  }

  // ***************************************************************************
  // *** CONSTRUCTOR ***
  // ***************************************************************************

  _XShelf.forScalarQuickExtraDataLoadAction({
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
    _XScalar xScalar = xScalarMap[scalar.name]!;
    setVipXScalar(xScalar: xScalar);
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
    for (_XFormModel xFormModel in allXFormModels) {
      print(" --> XShelf/FormModel: ${xFormModel.xBlock.name} - $xFormModel");
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  _XFilterModel? findXFilterModelByName(String name) {
    return xFilterModelMap[name];
  }

  _XBlock? findXBlockByName(String name) {
    return xBlockMap[name];
  }

  _XScalar? findXScalarByName(String name) {
    return xScalarMap[name];
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  _XScalar? nextXScalarTask() {
    for (_XScalar xScalar in allXScalars) {
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

  _XBlock? nextRootXBlockTask() {
    for (_XBlock xBlock in allRootXBlocks) {
      if (xBlock.hasQryHintInTreeBranchAndNotProcessed()) {
        return xBlock;
      }
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  void printInfo() {
    for (_XScalar xScalar in allXScalars) {
      if (xScalar.queryHint != QryHint.none) {
        xScalar.printInfo();
      }
    }
    for (_XBlock xBlock in allRootXBlocks) {
      xBlock.printInfoCascade();
    }
    for (_XFormModel xFormModel in allXFormModels) {
      xFormModel.printInfo();
    }
  }
}
