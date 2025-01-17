part of '../flutter_artist.dart';

class _XShelf {
  final Shelf shelf;

  // All DataFilters
  final List<_XDataFilter> xDataFilters = [];

  // All Root Blocks
  final List<_XBlock> rootXBlocks = [];

  // All Scalars
  final List<_XScalar> xScalars = [];

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
    required DataFilter? forceDataFilter,
    required FilterSnapshot? suggestedFilterSnapshot,
    required List<Scalar> forceQueryScalars,
    required List<Block> forceQueryBlocks,
    required List<BlockForm> forceQueryBlockForms,
  }) {
    if (forceDataFilter != null) {
      assert(forceDataFilter.shelf == shelf);
    }
    if (forceDataFilter != null && suggestedFilterSnapshot != null) {
      assert(forceDataFilter.getFilterSnapshotTypeAsString() ==
          suggestedFilterSnapshot.runtimeType.toString());
    }
    for (Scalar s in forceQueryScalars) {
      assert(s.shelf == shelf);
    }
    for (Block b in forceQueryBlocks) {
      assert(b.shelf == shelf);
    }
    for (BlockForm f in forceQueryBlockForms) {
      assert(f.block.shelf == shelf);
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
        siblingXBlocks: rootXBlocks,
      );
    }
    //
    if (forceDataFilter != null && suggestedFilterSnapshot != null) {
      __setSuggestedFilterSnapshot(
        dataFilter: forceDataFilter,
        suggestedFilterSnapshot: suggestedFilterSnapshot,
      );
    }
    __setForceQueryScalars(forceQueryScalars);
    __setForceQueryBlocks(forceQueryBlocks);
    __setForceQueryBlockForms(forceQueryBlockForms);
  }

  // ***************************************************************************
  // SET FORCE QUERY:
  // ***************************************************************************

  void __setSuggestedFilterSnapshot({
    required DataFilter dataFilter,
    required FilterSnapshot suggestedFilterSnapshot,
  }) {
    _XDataFilter xDataFilter = allXDataFilterMap[dataFilter.name]!;
    xDataFilter.suggestedFilterSnapshot = suggestedFilterSnapshot;
  }

  void __setForceQueryScalars(List<Scalar> forceQueryScalars) {
    // Force query:
    for (Scalar s in forceQueryScalars) {
      _XScalar xScalar = allXScalarMap[s.name]!;
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
      // TODO: Cần so sánh FilterSnapshot của Scalar và DataFilter.
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
      // TODO: Cần so sánh FilterSnapshot của Block và DataFilter.
      if (active && lazyOrError) {
        xBlock.needQuery = true;
      }
    }
    if (xBlock.xBlockParent != null) {
      __setForceQueryIfNeedCascade(xBlock.xBlockParent!);
    }
  }

  void __setForceQueryBlocks(List<Block> forceQueryBlocks) {
    // Force query:
    for (Block b in forceQueryBlocks) {
      _XBlock xBlock = allXBlockMap[b.name]!;
      xBlock.needQuery = true;
    }
    // Optional Query:
    for (_XBlock xBlock in allXBlockMap.values) {
      __setForceQueryIfNeedCascade(xBlock);
    }
  }

  void __setForceQueryBlockForms(List<BlockForm> forceQueryBlockForms) {
    // Force query:
    for (BlockForm f in forceQueryBlockForms) {
      _XBlockForm xBlockForm = allXBlockFormMap[f.block.name]!;
      xBlockForm.needQuery = true;
    }
    // Optional Query:
    for (_XBlockForm xBlockForm in allXBlockFormMap.values) {
      if (!xBlockForm.needQuery) {
        final BlockForm blockForm = xBlockForm.blockForm;
        final bool active = blockForm.hasActiveFormWidget();
        final bool lazyOrError = blockForm.dataState != DataState.ready;
        // TODO: Cần so sánh FilterSnapshot ???
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
    xDataFilters.add(xDataFilter);
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
    xScalars.add(xScalar);
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
        : _XBlockForm(blockForm: block.blockForm!);
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
}
