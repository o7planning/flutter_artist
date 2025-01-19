part of '../flutter_artist.dart';

class _XShelf {
  final Shelf shelf;

  // All DataFilters
  final List<_XDataFilter> allXDataFilters = [];

  // All Root Blocks
  final List<_XBlock> allRootXBlocks = [];

  // All Scalars
  final List<_XScalar> allXScalars = [];

  // All Scalars
  final List<_XBlockForm> allXBlockForms = [];

  // All DataFilters of Shelf
  // <String dataFilterName, _XScalar>
  final Map<String, _XDataFilter> allXDataFilterMap = {};

  // All Scalars of Shelf
  // <String scalarName, _XScalar>
  final Map<String, _XScalar> allXScalarMap = {};

  // All Blocks of Shelf
  // <String blockName, _XBlock>
  final Map<String, _XBlock> allXBlockMap = {};

  // All BlockForm of Shelf
  // <String blockName, _XBlockForm>
  final Map<String, _XBlockForm> allXBlockFormMap = {};

  _XShelf({
    required this.shelf,
    required _DataFilterOpt? forceDataFilterOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_BlockFormOpt> forceQueryBlockFormOpts,
  }) {
    if (forceDataFilterOpt != null) {
      assert(forceDataFilterOpt.dataFilter.shelf == shelf);
    }
    for (_ScalarOpt scalarOpt in forceQueryScalarOpts) {
      assert(scalarOpt.scalar.shelf == shelf);
    }
    for (_BlockOpt blockOpt in forceQueryBlockOpts) {
      assert(blockOpt.block.shelf == shelf);
    }
    for (_BlockFormOpt blockFormOpt in forceQueryBlockFormOpts) {
      assert(blockFormOpt.blockForm.shelf == shelf);
    }
    //
    for (DataFilter dataFilter in shelf._allDataFilters) {
      __addXDataFilter(
        dataFilter: dataFilter,
      );
    }
    //
    for (Scalar scalar in shelf.scalars) {
      __addXScalar(
        scalar: scalar,
      );
    }
    for (Block rootBlock in shelf.rootBlocks) {
      __addXBlockCascade(
        block: rootBlock,
        xBlockParent: null,
        siblingXBlocks: allRootXBlocks,
      );
    }
    //
    __setForceDataFilter(forceDataFilterOpt);
    __setForceQueryScalars(forceQueryScalarOpts);
    __setForceQueryBlocks(forceQueryBlockOpts);
    __setForceQueryBlockForms(forceQueryBlockFormOpts);
  }

  _XBlock? findXBlockByName(String name) {
    return allXBlockMap[name];
  }

  // ***************************************************************************
  // SET FORCE QUERY:
  // ***************************************************************************

  void __setForceDataFilter(_DataFilterOpt? forceDataFilter) {
    if (forceDataFilter != null && forceDataFilter.filterInput != null) {
      _XDataFilter xDataFilter =
          allXDataFilterMap[forceDataFilter.dataFilter.name]!;
      xDataFilter.filterInput = forceDataFilter.filterInput;
    }
  }

  void __setForceQueryScalars(List<_ScalarOpt> forceQueryScalars) {
    // Force query:
    for (_ScalarOpt scalarOpt in forceQueryScalars) {
      Scalar scalar = scalarOpt.scalar;
      _XScalar xScalar = allXScalarMap[scalar.name]!;
      xScalar.needQuery = true;
    }
    // Optional Query:
    for (_XScalar xScalar in allXScalarMap.values) {
      if (xScalar.needQuery) {
        continue;
      }
      final Scalar scalar = xScalar.scalar;
      final bool active = scalar.hasActiveUiComponent();
      final bool lazyOrError = scalar.dataState != DataState.ready;
      // TODO: Cần so sánh FilterCriteria của Scalar và DataFilter.
      if (active && lazyOrError) {
        xScalar.needQuery = true;
      }
    }
  }

  // Up to Root Block.
  void __setForceQueryIfNeedCascade(_XBlock xBlock) {
    if (!xBlock.needQuery) {
      final Block block = xBlock.block;
      final bool active = block.hasActiveUiComponent();
      final bool lazyOrError = block.dataState != DataState.ready;
      // TODO: Cần so sánh FilterCriteria của Block và DataFilter.
      if (active && lazyOrError) {
        xBlock.needQuery = true;
      }
    }
    if (xBlock.xBlockParent != null) {
      __setForceQueryIfNeedCascade(xBlock.xBlockParent!);
    }
  }

  void __setForceQueryBlocks(List<_BlockOpt> forceQueryBlocks) {
    // Force query:
    for (_BlockOpt blockOpt in forceQueryBlocks) {
      Block block = blockOpt.block;
      _XBlock xBlock = allXBlockMap[block.name]!;
      xBlock.needQuery = true;
      xBlock.setOptions(
        queryType: blockOpt.queryType,
        listBehavior: blockOpt.listBehavior,
        suggestedSelection: blockOpt.suggestedSelection,
        postQueryBehavior: blockOpt.postQueryBehavior,
        pageable: blockOpt.pageable,
      );
    }
    // Optional Query:
    for (_XBlock xBlock in allXBlockMap.values) {
      __setForceQueryIfNeedCascade(xBlock);
    }
  }

  void __setForceQueryBlockForms(List<_BlockFormOpt> forceQueryBlockForms) {
    // Force query:
    for (_BlockFormOpt blockFormOpt in forceQueryBlockForms) {
      BlockForm blockForm = blockFormOpt.blockForm;
      _XBlockForm xBlockForm = allXBlockFormMap[blockForm.block.name]!;
      xBlockForm.needQuery = true;
    }
    // Optional Query:
    for (_XBlockForm xBlockForm in allXBlockFormMap.values) {
      if (!xBlockForm.needQuery) {
        final BlockForm blockForm = xBlockForm.blockForm;
        final bool active = blockForm.hasActiveFormWidget();
        final bool lazyOrError = blockForm.dataState != DataState.ready;
        // TODO: Cần so sánh FilterCriteria ???
        if (active && lazyOrError) {
          xBlockForm.needQuery = true;
        }
      }
      if (xBlockForm.needQuery) {
        __setForceQueryIfNeedCascade(xBlockForm.xBlock);
      }
    }
  }

  // ***************************************************************************
  //
  // ***************************************************************************

  void __addXDataFilter({
    required DataFilter dataFilter,
  }) {
    _XDataFilter xDataFilter = _XDataFilter(dataFilter: dataFilter);
    //
    allXDataFilters.add(xDataFilter);
    allXDataFilterMap[xDataFilter.name] = xDataFilter;
  }

  void __addXScalar({
    required Scalar scalar,
  }) {
    _XDataFilter xDataFilter =
        allXDataFilterMap[scalar._registeredOrDefaultDataFilter.name]!;
    //
    _XScalar xScalar = _XScalar(
      scalar: scalar,
      xDataFilter: xDataFilter,
    );
    //
    allXScalars.add(xScalar);
    allXScalarMap[scalar.name] = xScalar;
  }

  void __addXBlockCascade({
    required Block block,
    required _XBlock? xBlockParent,
    required List<_XBlock> siblingXBlocks,
  }) {
    _XDataFilter xDataFilter =
        allXDataFilterMap[block._registeredOrDefaultDataFilter.name]!;
    //
    _XBlockForm? xBlockForm = block.blockForm == null //
        ? null
        : _XBlockForm(
            blockForm: block.blockForm!,
            suggestedFormData: null,
          );
    //
    _XBlock xBlock = _XBlock(
      block: block,
      xBlockParent: xBlockParent,
      xDataFilter: xDataFilter,
      xBlockForm: xBlockForm,
    );
    xBlockForm?.xBlock = xBlock;
    siblingXBlocks.add(xBlock);
    //
    allXBlockMap[block.name] = xBlock;
    if (xBlockForm != null) {
      allXBlockForms.add(xBlockForm);
      allXBlockFormMap[block.name] = xBlockForm;
    }
    //
    for (Block childBlock in block._childBlocks) {
      __addXBlockCascade(
        block: childBlock,
        xBlockParent: xBlock,
        siblingXBlocks: xBlock.childXBlocks,
      );
    }
  }

  void printMe() {
    for (String key in allXBlockMap.keys) {
      print("XShelf/block: $key - ${allXBlockMap[key]}");
    }
  }
}
