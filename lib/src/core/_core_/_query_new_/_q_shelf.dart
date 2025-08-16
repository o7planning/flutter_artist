part of '../core.dart';

int __qShelfIdSequence = 0;

enum QShelfType {
  naturalQuery;
}

class _QShelf {
  final QShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  final Map<String, _QFilterModel> xFilterModelMap = {};
  final Map<String, _QFormModel> xFormModelMap = {};
  final Map<String, _QScalar> xScalarMap = {};
  final Map<String, _QBlock> xBlockMap = {};

  final List<_QBlock> rootXBlocks = [];
  final List<_QBlock> leafXBlocks = [];
  final List<_QScalar> allXScalars = [];
  final List<_QBlock> allXBlocks = [];
  final List<_QFilterModel> allXFilterModels = [];
  final List<_QFormModel> allXFormModels = [];

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
      allXBlocks.add(xBlock);
      xBlockMap[block.name] = xBlock;
      //
      if (block.parent == null) {
        rootXBlocks.add(xBlock);
      }
      if (block.childBlocks.isEmpty) {
        leafXBlocks.add(xBlock);
      }
    }
    //
    for (Block block in shelf.blocks) {
      _QBlock xBlock = xBlockMap[block.name]!;
      Block? parent = block.parent;
      if (parent != null) {
        _QBlock xBlockParent = xBlockMap[parent.name]!;
        xBlock.parentXBlock = xBlockParent;
      } else {
        xBlock.parentXBlock = null;
      }
    }
  }

  // ***************************************************************************

  _QShelf.naturalQuery({required this.shelf})
      : xShelfType = QShelfType.naturalQuery {
    __initCore(shelf: shelf);
    //
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
}
