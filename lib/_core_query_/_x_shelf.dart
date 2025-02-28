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
    __setForceDataFilterOpt(forceDataFilterOpt);
    __setForceQueryScalarOpts(forceQueryScalarOpts);
    __setForceQueryBlockOpts(forceQueryBlockOpts);
    __setForceQueryBlockFormOpts(forceQueryBlockFormOpts);
  }

  _XBlock? findXBlockByName(String name) {
    return allXBlockMap[name];
  }

  _XScalar? findXScalarByName(String name) {
    return allXScalarMap[name];
  }

  // ***************************************************************************
  // SET FORCE QUERY:
  // ***************************************************************************

  void __setForceDataFilterOpt(_DataFilterOpt? forceDataFilterOpt) {
    if (forceDataFilterOpt != null && forceDataFilterOpt.filterInput != null) {
      _XDataFilter xDataFilter =
      allXDataFilterMap[forceDataFilterOpt.dataFilter.name]!;
      xDataFilter.filterInput = forceDataFilterOpt.filterInput;

      DataFilter dataFilter = forceDataFilterOpt.dataFilter;

      //
      // TODO: Đang kiểm tra các Block hoặc Scalar nào bị ảnh hưởng bởi FilterInput trên.
      //
      for (Scalar scalar in dataFilter.scalars) {
        _XScalar xScalar = allXScalarMap[scalar.name]!;
        // TODO: Chưa sử dụng thuộc tính này.
        xScalar.affectByFilterInput = true;
      }
      for (Block block in dataFilter.blocks) {
        _XBlock xBlock = allXBlockMap[block.name]!;
        // TODO: Chưa sử dụng thuộc tính này.
        xBlock.affectByFilterInput = true;
      }
    }
  }

  void __setForceQueryScalarOpts(List<_ScalarOpt> forceQueryScalarOpts) {
    // Force query:
    for (_ScalarOpt scalarOpt in forceQueryScalarOpts) {
      Scalar scalar = scalarOpt.scalar;
      _XScalar xScalar = allXScalarMap[scalar.name]!;
      xScalar.setForceQuery();
    }
  }

  void __setForceQueryForAncestorBlocks({
    required List<Block> descendingAncestorBlocks,
  }) {
    List<_XBlock> descendingAncestorXBlocks = descendingAncestorBlocks.map((b) {
      return allXBlockMap[b.name]!;
    }).toList();

    bool found = false;

    // ---> Descending --->
    for (_XBlock ancestorXBlock in descendingAncestorXBlocks) {
      if (!found) {
        bool needToQuery = ancestorXBlock.block._needToQuery();
        if (needToQuery) {
          found = true;
        }
      }
      //
      if (found) {
        ancestorXBlock.setForceQuery();
      }
    }
  }

  void __setForceQueryBlockOpt(_BlockOpt forceQueryBlockOpt) {
    Block block = forceQueryBlockOpt.block;
    _XBlock xBlock = allXBlockMap[block.name]!;
    xBlock.setForceQuery();
    //
    xBlock.setOptions(
      queryType: forceQueryBlockOpt.queryType,
      listBehavior: forceQueryBlockOpt.listBehavior,
      suggestedSelection: forceQueryBlockOpt.suggestedSelection,
      postQueryBehavior: forceQueryBlockOpt.postQueryBehavior,
      pageable: forceQueryBlockOpt.pageable,
    );
    //
    List<Block> descendingAncestorBlocks = block.descendingAncestorBlocks;
    //
    __setForceQueryForAncestorBlocks(
      descendingAncestorBlocks: descendingAncestorBlocks,
    );
  }

  void __setForceQueryBlockOpts(List<_BlockOpt> forceQueryBlockOpts) {
    // Force query:
    for (_BlockOpt blockOpt in forceQueryBlockOpts) {
      __setForceQueryBlockOpt(blockOpt);
    }
  }

  void __setForceQueryBlockFormOpts(List<_BlockFormOpt> forceQueryBlockForms) {
    // Force query:
    for (_BlockFormOpt blockFormOpt in forceQueryBlockForms) {
      BlockForm blockForm = blockFormOpt.blockForm;
      _XBlockForm xBlockForm = allXBlockFormMap[blockForm.block.name]!;
      xBlockForm.needQuery = true;
      // Set Force query to Ascending Ancestor Blocks:
      List<Block> descendingAncestorBlocks = [
        ...blockForm.block.descendingAncestorBlocks,
        blockForm.block
      ];
      __setForceQueryForAncestorBlocks(
        descendingAncestorBlocks: descendingAncestorBlocks,
      );
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
      extraFormInput: null,
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
