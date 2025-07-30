part of '../core.dart';

int __xShelfIdSequence = 0;

class _XShelf {
  final bool naturalMode;

  late final int xShelfId;

  final Shelf shelf;

  // All FilterModels
  final List<_XFilterModel> allXFilterModels = [];

  // All Root Blocks
  final List<_XBlock> allRootXBlocks = [];

  // All Scalars
  final List<_XScalar> allXScalars = [];

  // All Scalars
  final List<_XFormModel> allXFormModels = [];

  // All FilterModels of Shelf
  // <String filterModelName, _XScalar>
  final Map<String, _XFilterModel> allXFilterModelMap = {};

  // All Scalars of Shelf
  // <String scalarName, _XScalar>
  final Map<String, _XScalar> allXScalarMap = {};

  // All Blocks of Shelf
  // <String blockName, _XBlock>
  final Map<String, _XBlock> allXBlockMap = {};

  // All FormModels of Shelf
  // <String blockName, _XFormModel>
  final Map<String, _XFormModel> allXFormModelMap = {};

  _XShelf({
    this.naturalMode = false,
    required this.shelf,
    required _FilterModelOpt? forceFilterModelOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) {
    xShelfId = __xShelfIdSequence++;
    //
    if (forceFilterModelOpt != null) {
      assert(forceFilterModelOpt.filterModel.shelf == shelf);
    }
    for (_ScalarOpt scalarOpt in forceQueryScalarOpts) {
      assert(scalarOpt.scalar.shelf == shelf);
    }
    for (_BlockOpt blockOpt in forceQueryBlockOpts) {
      assert(blockOpt.block.shelf == shelf);
    }
    for (_FormModelOpt formModelOpt in forceQueryFormModelOpts) {
      assert(formModelOpt.formModel.shelf == shelf);
    }
    //
    for (FilterModel filterModel in shelf._allFilterModels) {
      __addXFilterModel(
        filterModel: filterModel,
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
    __setForceFilterModelOpt(forceFilterModelOpt);
    //
    __setForceQueryScalarOpts(
      naturalMode: naturalMode,
      forceQueryScalarOpts: forceQueryScalarOpts,
    );
    __setForceQueryBlockOpts(
      naturalMode: naturalMode,
      forceQueryBlockOpts: forceQueryBlockOpts,
    );
    __setForceQueryFormModelOpts(
      naturalMode: naturalMode,
      forceQueryFormModelOpts: forceQueryFormModelOpts,
    );
  }

  _XFilterModel? findXFilterModelByName(String name) {
    return allXFilterModelMap[name];
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

  void __setForceFilterModelOpt(_FilterModelOpt? forceFilterModelOpt) {
    if (forceFilterModelOpt != null &&
        forceFilterModelOpt.filterInput != null) {
      _XFilterModel xFilterModel =
          allXFilterModelMap[forceFilterModelOpt.filterModel.name]!;
      xFilterModel.filterInput = forceFilterModelOpt.filterInput;

      FilterModel filterModel = forceFilterModelOpt.filterModel;

      //
      // TODO: Đang kiểm tra các Block hoặc Scalar nào bị ảnh hưởng bởi FilterInput trên.
      //
      for (Scalar scalar in filterModel.scalars) {
        _XScalar xScalar = allXScalarMap[scalar.name]!;
        // TODO: Chưa sử dụng thuộc tính này.
        xScalar.affectByFilterInput = true;
      }
      for (Block block in filterModel.blocks) {
        _XBlock xBlock = allXBlockMap[block.name]!;
        // TODO: Chưa sử dụng thuộc tính này.
        xBlock.affectByFilterInput = true;
      }
    }
  }

  void __setForceQueryScalarOpts({
    required bool naturalMode,
    required List<_ScalarOpt> forceQueryScalarOpts,
  }) {
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
    if (forceQueryBlockOpt.forceQuery) {
      xBlock.setForceQuery();
    }
    if (forceQueryBlockOpt.forceReloadItem) {
      xBlock.setForceReloadItem();
    }
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
    print(">>>>>>>> descendingAncestorBlocks: $descendingAncestorBlocks");
    //
    __setForceQueryForAncestorBlocks(
      descendingAncestorBlocks: descendingAncestorBlocks,
    );
  }

  void __setForceQueryBlockOpts({
    required bool naturalMode,
    required List<_BlockOpt> forceQueryBlockOpts,
  }) {
    // Force query:
    for (_BlockOpt blockOpt in forceQueryBlockOpts) {
      __setForceQueryBlockOpt(blockOpt);
    }
  }

  void __setForceQueryFormModelOpts({
    required bool naturalMode,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) {
    // Force query:
    for (_FormModelOpt formModelOpt in forceQueryFormModelOpts) {
      FormModel formModel = formModelOpt.formModel;
      _XFormModel xFormModel = allXFormModelMap[formModel.block.name]!;
      if (naturalMode) {
        xFormModel.forceTypeForForm = ForceType.decidedAtRuntime;
      } else {
        xFormModel.forceTypeForForm = ForceType.force;
      }
      // Set Force query to Ascending Ancestor Blocks:
      List<Block> descendingAncestorBlocks = [
        ...formModel.block.descendingAncestorBlocks,
        formModel.block
      ];
      __setForceQueryForAncestorBlocks(
        descendingAncestorBlocks: descendingAncestorBlocks,
      );
    }
  }

  // ***************************************************************************
  //
  // ***************************************************************************

  void __addXFilterModel({
    required FilterModel filterModel,
  }) {
    _XFilterModel xFilterModel = _XFilterModel(
      xShelf: this,
      filterModel: filterModel,
    );
    //
    allXFilterModels.add(xFilterModel);
    allXFilterModelMap[xFilterModel.name] = xFilterModel;
  }

  void __addXScalar({
    required Scalar scalar,
  }) {
    _XFilterModel xFilterModel =
        allXFilterModelMap[scalar._registeredOrDefaultFilterModel.name]!;
    //
    _XScalar xScalar = _XScalar(
      xShelf: this,
      scalar: scalar,
      xFilterModel: xFilterModel,
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
    _XFilterModel xFilterModel =
        allXFilterModelMap[block._registeredOrDefaultFilterModel.name]!;
    //
    _XFormModel? xFormModel = block.formModel == null //
        ? null
        : _XFormModel(
            xShelf: this,
            formModel: block.formModel!,
            extraFormInput: null,
          );
    //
    _XBlock xBlock = _XBlock(
      xShelf: this,
      block: block,
      xBlockParent: xBlockParent,
      xFilterModel: xFilterModel,
      xFormModel: xFormModel,
    );
    xFormModel?.xBlock = xBlock;
    siblingXBlocks.add(xBlock);
    //
    allXBlockMap[block.name] = xBlock;
    if (xFormModel != null) {
      allXFormModels.add(xFormModel);
      allXFormModelMap[block.name] = xFormModel;
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
    print("\nXShelf BEFORE QUERY:");
    for (String key in allXBlockMap.keys) {
      print(" --> XShelf/Block: $key - ${allXBlockMap[key]}");
    }
    for (String key in allXScalarMap.keys) {
      print(" --> XShelf/Scalar: $key - ${allXScalarMap[key]}");
    }
    for (_XFormModel xFormModel in allXFormModels) {
      print(
          " --> XShelf/FormModel: ${xFormModel.formModel.block.name} - $xFormModel");
    }
  }
}
