part of '../flutter_artist.dart';

class _XShelf {
  final Shelf shelf;
  final List<_XBlock> rootXBlocks = [];
  final List<_XScalar> xScalars = [];

  // All Scalars of Shelf
  final Map<String, _XScalar> allXScalarMap = {};

  // All Blocks of Shelf
  final Map<String, _XBlock> allXBlockMap = {};

  // All BlockForm of Shelf
  final Map<String, _XBlockForm> allXBlockFormMap = {};

  _XShelf({
    required this.shelf,
    required List<Scalar> forceQueryScalars,
    required List<Block> forceQueryBlocks,
    required List<BlockForm> forceQueryBlockForms,
  }) {
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
    for (Scalar scalar in shelf.scalars) {
      __addXScalar(
        scalar: scalar,
        siblingXScalars: xScalars,
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
    __setForceQueryScalars(forceQueryScalars);
    __setForceQueryBlocks(forceQueryBlocks);
    __setForceQueryBlockForms(forceQueryBlockForms);
  }

  // ***************************************************************************
  // SET FORCE QUERY:
  // ***************************************************************************

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

  void __addXScalar({
    required Scalar scalar,
    required List<_XScalar> siblingXScalars,
  }) {
    _XScalar xScalar = _XScalar(scalar);
    siblingXScalars.add(xScalar);
    //
    allXScalarMap[scalar.name] = xScalar;
  }

  void __addXBlockCascade({
    required Block block,
    required _XBlock? xBlockParent,
    required List<_XBlock> siblingXBlocks,
  }) {
    _XBlockForm? xBlockForm = block.blockForm == null //
        ? null
        : _XBlockForm(blockForm: block.blockForm!);
    _XBlock xBlock = _XBlock(
      block: block,
      xBlockParent: xBlockParent,
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
