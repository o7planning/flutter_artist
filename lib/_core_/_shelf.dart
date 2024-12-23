part of '../flutter_artist.dart';

abstract class Shelf {
  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  final Map<String, Block> __blockMap = {};

  final List<Block> __rootBlocks = [];

  bool _isStructError = false;

  String? _structError;

  bool get isStructError => _isStructError;

  String? get structError => _structError;

  List<Block> get rootBlocks => [...__rootBlocks];

  int __lastTransactionNumber = 0;

  int __currentTransactionNumber = 0;

  final List<Block> __lazyBlocksToQuery = [];

  bool _queryLocked = false;

  String get name => Storage._getShelfName(runtimeType);

  Shelf() {
    __onInit();
  }

  void __onInit() {
    _shelfStruct = registerStructure();

    for (String blockFilterName in _shelfStruct.blockFilters.keys) {
      BlockFilter blockFilter = _shelfStruct.blockFilters[blockFilterName]!;
      blockFilter.name = blockFilterName;
      blockFilter.shelf = this;
    }

    List<Block> rootBlocks = _shelfStruct.blocks;
    for (Block rootBlock in rootBlocks) {
      rootBlock.parent = null;
      __rootBlocks.add(rootBlock);
      __registerBlockCascade(rootBlock);
    }
  }

  void __registerBlockCascade(Block block) {
    __blockMap[block.name] = block;
    block.shelf = this;
    if (block.blockFilterName != null) {
      BlockFilter? blockFilter =
          _shelfStruct.blockFilters[block.blockFilterName!];
      if (blockFilter == null) {
        throw "BlockFilter not found '${block.blockFilterName}'";
      }
      const Type filterSnapshotType = FilterSnapshot;
      final String filterSnapshotBase = filterSnapshotType.toString();
      final String filterSnapshotBF =
          blockFilter.getFilterSnapshotTypeAsString();
      final String filterSnapshotB = block.getFilterSnapshotTypeAsString();
      //
      if (filterSnapshotBF == filterSnapshotBase) {
        throw "You need to create your own class that extends from '$filterSnapshotBase' "
            "as Filter-Snapshot for '${getClassName(blockFilter)}'\n"
            " >> Currently, Filter-Snapshot of '${getClassName(blockFilter)}' Block-Filter is '$filterSnapshotBF'\n";
      }
      //
      if (filterSnapshotBF != filterSnapshotB) {
        throw "Block and Block-Filter must have the same Filter-Snapshot type.\n"
            " >> Filter-Snapshot of '${getClassName(block)}' Block is '$filterSnapshotB'\n"
            " >> Filter-Snapshot of '${getClassName(blockFilter)}' Block-Filter is '$filterSnapshotBF'\n";
      }
      //
      blockFilter._blocks.add(block);
      block.blockFilter = blockFilter;
    } else {
      block.blockFilter = null;
      //
      const Type emptyFilterSnapshotType = EmptyFilterSnapshot;
      final String filterSnapshotEmpty = emptyFilterSnapshotType.toString();
      final String filterSnapshotB = block.getFilterSnapshotTypeAsString();
      //
      if (filterSnapshotB != filterSnapshotEmpty) {
        throw "Filter-Snapshot of '${getClassName(block)}' block must be '$filterSnapshotEmpty' "
            "because this block does not have a Block-Filter.\n"
            " >> Currently, its Filter-Snapshot is '$filterSnapshotB'\n";
      }
    }
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  List<Block> get blocks {
    List<Block> ret = [];
    for (Block rootBlock in __rootBlocks) {
      ret.add(rootBlock);
      ret.addAll(rootBlock.descendantBlocks);
    }
    return ret;
  }

  // Local Use
  bool _isChangeListener() {
    for (Block block in blocks) {
      if (block.isChangeListener) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ShelfStructure registerStructure();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showMessageDialog(
      {required String message, String? details}) async {
    BuildContext context = Storage.adapter.getCurrentContext();
    await _showMessageDialog(
      context: context,
      message: message,
      details: details,
    );
  }

  Future<void> showShelfStructureDialog() async {
    BuildContext context = Storage.adapter.getCurrentContext();
    await _showStorageDialog(context: context, shelf: this);
  }

  Future<void> showActiveUiComponentsDialog() async {
    BuildContext context = Storage.adapter.getCurrentContext();
    await _showActiveUiComponentsDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Block? findBlock(String blockName) {
    return __blockMap[blockName];
  }

  BlockFilter? findBlockFilter(String blockFilterName) {
    return _shelfStruct.blockFilters[blockFilterName];
  }

  List<String> get filterNames => [..._shelfStruct.blockFilters.keys];

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __findMountedWidgetStates({
    required List<Block> blocks,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
    required bool withPagination,
    required Map<_WidgetState, bool> founds,
  }) {
    for (Block block in blocks) {
      Map<_WidgetState, bool> m = block._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
      );
      founds.addAll(m);
      __findMountedWidgetStates(
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        activeOnly: activeOnly,
        blocks: block.childBlocks,
        founds: founds,
      );
    }
  }

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_WidgetState, bool> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      activeOnly: activeOnly,
      blocks: __rootBlocks,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<void> _startNewLazyQueryTransactionIfNeed() async {
    if (_queryLocked) {
      await Future.doWhile(
        () => Future.delayed(const Duration(milliseconds: 5))
            .then((_) => _queryLocked),
      );
    }

    if (__currentTransactionNumber == __lastTransactionNumber) {
      __currentTransactionNumber++;
      __lazyBlocksToQuery.clear();

      print(
          "\n\n@@@@@@@>>>>>>>>>>>>>>> _startNewLazyQueryTransactionIfNeed - ID: $__currentTransactionNumber");

      Timer(
        const Duration(milliseconds: 0), // 200
        __queryLazyList,
      );
    }
  }

  Future<void> __queryLazyList() async {
    _queryLocked = true;
    final List<BlockAndFormWraper> lazyBlockOrForms = __findTopLazyBlocks();
    if (lazyBlockOrForms.isEmpty) {
      __lastTransactionNumber = __currentTransactionNumber;
      _queryLocked = false;
      return;
    } else {
      print("@@@@@@@@@@@@ __queryLazyList: ID: $__currentTransactionNumber");
      __lastTransactionNumber = __currentTransactionNumber;

      print(
          "@@@@@@@@@@@@ __queryLazyList: ID:  Start >>>>>>>>>>> lazyBlockOrForms: $lazyBlockOrForms");
      await _queryBlockOrForms(
        queryType: QueryType.forceQuery,
        blockOrForms: lazyBlockOrForms,
      );
      print(
          "@@@@@@@@@@@@ __queryLazyList: ID:  End >>>>>>>>>>> lazyBlockOrForms: $lazyBlockOrForms");
      _queryLocked = false;
    }
  }

  void __findTopLazyBlocksCascade(
      List<Block> blocks, List<BlockAndFormWraper> founds) {
    for (Block block in blocks) {
      // _hasActiveWidgetAndNeedToQuery()
      if (block.hasActiveBlockFragmentWidget(alsoCheckChildren: true) &&
          block.dataState == DataState.pending) {
        founds.add(BlockAndFormWraper.block(block));
      } else if (block.blockForm != null &&
          block.blockForm!.hasActiveFormWidget() &&
          block.blockForm!.dataState == DataState.pending) {
        founds.add(BlockAndFormWraper.blockForm(block.blockForm!));
      } else {
        __findTopLazyBlocksCascade(block._childBlocks, founds);
      }
    }
  }

  List<BlockAndFormWraper> __findTopLazyBlocks() {
    final List<BlockAndFormWraper> founds = [];
    __findTopLazyBlocksCascade(__rootBlocks, founds);
    return founds;
  }

  Future<bool> _queryBlocks({
    required QueryType queryType,
    required List<Block> blocks,
  }) async {
    List<BlockAndFormWraper> blockOrForms =
        blocks.map((b) => BlockAndFormWraper.block(b)).toList();
    return await _queryBlockOrForms(
      queryType: queryType,
      blockOrForms: blockOrForms,
    );
  }

  // TODO Kiem tra cha con cua cac Block.
  Future<bool> _queryBlockOrForms({
    required QueryType queryType,
    required List<BlockAndFormWraper> blockOrForms,
  }) async {
    if (blockOrForms.isEmpty) {
      return true;
    }
    bool needToUpdate = false;
    bool success = false;
    try {
      print(
          "@@@@@@@@@@@@@@@@@@@@@@@@@@@ >>>>>>>>>>> queryBlocks: $blockOrForms");

      for (BlockAndFormWraper blkOrForm in blockOrForms) {
        needToUpdate = true;
        if (blkOrForm.block != null) {
          Storage.codeFlowLogger._addInfo(
            isLibCode: true,
            object: this,
            info: "Querying lazy block: ${getClassName(blkOrForm.block)}",
          );
          //
          success = await blkOrForm.block!._queryWithOverlayAndRestorable(
            queryType: queryType,
            listBehavior: ListBehavior.replace,
            suggestedFilterData: null,
            postQueryBehavior: PostQueryBehavior.selectAvailableItem,
            suggestedSelection: null,
            pageable: null, // TODO: Reset?
          );
          if (!success) {
            break;
          }
        } else if (blkOrForm.blockForm != null) {
          Storage.codeFlowLogger._addInfo(
            isLibCode: true,
            object: this,
            info:
                "Querying lazy block form: ${getClassName(blkOrForm.blockForm)}",
          );
          //
          Block block = blkOrForm.blockForm!.block;
          Object? currentItem = block.data.currentItemDetail;
          if (currentItem != null) {
            success = await block._prepareToShowOrEditWithOverlayAndRestorable(
              item: currentItem,
              justQueried: false,
              suggestedSelection: null,
              forceForm: true,
            );
            if (!success) {
              break;
            }
          }
        }
      }
    } catch (e) {
      success = false;
    }
    if (needToUpdate) {
      updateAllWidgets();
    }
    return success;
  }

  void __updateAllWidgetsCascade(Block block) {
    block.updateFragmentWidgets();
    block.updatePaginationWidgets();
    block.updateControlBarWidgets();
    block.blockForm?.updateFormWidgets();
    block.blockFilter?.updateWidgets();
    for (Block childBlock in block._childBlocks) {
      __updateAllWidgetsCascade(childBlock);
    }
  }

  void updateAllWidgets() {
    for (Block block in __rootBlocks) {
      __updateAllWidgetsCascade(block);
    }
  }
}
