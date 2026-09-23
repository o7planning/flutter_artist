part of '../../core.dart';

int __xShelfSequence = 0;

abstract class XShelf extends XRootQueueItem {
  final XShelfType xShelfType;
  final Shelf shelf;
  late final int xShelfId;

  int _executionUnitStep = 0;

  @override
  String get _fullName => "@XShelf-${shelf.name}";

  final Map<String, XFilterModel> xFilterModelMap = {};
  final Map<String, XBlockFormModel> xBlockFormModelMap = {};
  final Map<String, XScalar> xScalarMap = {};
  final Map<String, XBlock> xBlockMap = {};

  //
  final List<XBlock> allRootXBlocks = [];
  final List<XScalar> allRootXScalars = [];

  //
  final List<XBlock> allLeafXBlocks = [];
  final List<XScalar> allLeafXScalars = [];

  //
  final List<XScalar> allXScalars = [];
  final List<XBlock> allXBlocks = [];

  //
  final List<XFilterModel> allXFilterModels = [];
  final List<XBlockFormModel> allXBlockFormModels = [];

  bool get naturalMode => xShelfType == XShelfType.naturalQuery;

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  XShelf({
    required this.xShelfType,
    required this.shelf,
  }) : xShelfId = __xShelfSequence++ {
    for (FilterModel filterModel in shelf._allFilterModels) {
      //
      // Create XFilterModel from filterModel.
      //
      final xFilterModel = filterModel._createXFilterModel(xShelf: this);
      //
      xFilterModelMap[filterModel.name] = xFilterModel;
      allXFilterModels.add(xFilterModel);
    }
    for (Scalar scalar in shelf.scalars) {
      final FilterModel filterModel = scalar._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      // Create XScalar via 'scalar._createXScalar' method
      // to have the same Generics Parameters with scalar.
      //
      final xScalar = scalar._createXScalar(
        xFilterModel: xFilterModel,
      );
      xFilterModel.xScalars.add(xScalar);
      allXScalars.add(xScalar);
      xScalarMap[scalar.name] = xScalar;
      //
      if (scalar.parent == null) {
        allRootXScalars.add(xScalar);
      }
      if (scalar.childScalars.isEmpty) {
        allLeafXScalars.add(xScalar);
      }
    }
    //
    for (Scalar scalar in shelf.scalars) {
      XScalar xScalar = xScalarMap[scalar.name]!;
      Scalar? parent = scalar.parent;
      if (parent != null) {
        XScalar xScalarParent = xScalarMap[parent.name]!;
        xScalar.parentXScalar = xScalarParent;
        xScalarParent.childXScalars.add(xScalar);
      } else {
        xScalar.parentXScalar = null;
      }
    }
    //
    for (Block block in shelf.blocks) {
      final BlockFormModel? formModel = block.formModel;
      XBlockFormModel? xBlockFormModel;
      if (formModel != null) {
        //
        // Create new XBlockFormModel via 'formModel._createXBlockFormModel' method
        // to have the same Generics Parameters with block.
        //
        xBlockFormModel = formModel._createXBlockFormModel(formInput: null);
        allXBlockFormModels.add(xBlockFormModel);
        xBlockFormModelMap[formModel.block.name] = xBlockFormModel;
      }
      //
      final FilterModel filterModel = block._registeredOrDefaultFilterModel;
      final xFilterModel = xFilterModelMap[filterModel.name]!;
      //
      // Create new XBlock via 'block._createXBlock' method
      // to have the same Generics Parameters with block.
      //
      final xBlock = block._createXBlock(
        xFilterModel: xFilterModel,
        xBlockFormModel: xBlockFormModel,
      );
      xBlockFormModel?.xBlock = xBlock;
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
    //
    _updateFromShelfForFirstTime();
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _updateFromShelfForFirstTime() {
    for (XScalar leafXScalar in allLeafXScalars) {
      XScalar? xScalar = leafXScalar;
      while (xScalar != null) {
        final ScalarDataState dataState = xScalar.scalar.dataState;
        bool hasActiveUiX = xScalar.scalar.ui.hasVisibleContentView(
          includeDescendants: true,
        );
        if (hasActiveUiX) {
          if (xScalar.scalar.dataState.isPending ||
              xScalar.scalar.dataState.isStale) {
            xScalar.setQueryHintToGreater(QueryHint.force);
          }
        }
        xScalar = xScalar.parentXScalar;
      }
    }
    //
    for (XBlock leafXBlock in allLeafXBlocks) {
      XBlock? xBlock = leafXBlock;
      while (xBlock != null) {
        bool blockXBlockRep = xBlock.block.ui.hasBlockContext(
          includeDescendants: true,
        );
        if (blockXBlockRep) {
          if (xBlock.block.dataState.isPending ||
              xBlock.block.dataState.isStale) {
            xBlock.setQueryHintToGreater(QueryHint.force);
          }
        }
        XBlockFormModel? xBlockFormModel = xBlock.xBlockFormModel;
        if (xBlockFormModel != null &&
            xBlockFormModel.formModel.ui.hasVisibleViews()) {
          if (xBlockFormModel.formModel.dataState.isPending ||
              xBlockFormModel.formModel.dataState.isFatalError ||
              xBlockFormModel.formModel.dataState.isNone) {
            // Test case: [39b]
            if (naturalMode) {
              xBlockFormModel.setForceType(FormLoadHint.auto);
            } else {
              xBlockFormModel.setForceType(FormLoadHint.force);
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

  NxtExecutionUnit? _getNextExecutionUnit({required bool debug}) {
    if (debug) {
      if (++_executionUnitStep == 1) {
        print(
            "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      }
    }
    PrintUtils.debug(debug,
        "\nSHELF EXECUTION UNIT ($_executionUnitStep) >>> ${getClassNameWithoutGenerics(this)}._getNextExecutionUnit()...");
    NxtExecutionUnit? next = _findBlockNextExecutionUnit(debug: debug);
    if (next != null) {
      return next;
    }
    next = _findScalarNextExecutionUnit(debug: debug);
    if (next != null) {
      return next;
    }
    return null;
  }

  // ***************************************************************************

  NxtExecutionUnit? _findBlockNextExecutionUnit({required bool debug}) {
    for (final root in allRootXBlocks) {
      final NxtExecutionUnit? next =
          _findBlockNextExecutionUnitCascade(xBlock: root, debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }
    return null;
  }

  NxtExecutionUnit? _findBlockNextExecutionUnitCascade({
    required XBlock xBlock,
    required bool debug,
  }) {
    NxtExecutionUnit next1 = xBlock._getNextExecutionUnit(debug: debug);
    if (next1.yes) {
      return next1;
    }
    for (final XBlock childXBlock in xBlock.childXBlocks) {
      NxtExecutionUnit? next2 =
          _findBlockNextExecutionUnitCascade(xBlock: childXBlock, debug: debug);
      if (next2 != null && next2.yes) {
        return next2;
      }
    }
    return null;
  }

  // ***************************************************************************

  NxtExecutionUnit? _findScalarNextExecutionUnit({required bool debug}) {
    for (final root in allRootXScalars) {
      final NxtExecutionUnit? next =
          _findScalarNextExecutionUnitCascade(xScalar: root, debug: debug);
      if (next != null && next.yes) {
        return next;
      }
    }
    return null;
  }

  NxtExecutionUnit? _findScalarNextExecutionUnitCascade({
    required XScalar xScalar,
    required bool debug,
  }) {
    NxtExecutionUnit next1 = xScalar._getNextExecutionUnit(debug: debug);
    if (next1.yes) {
      return next1;
    }
    for (final XScalar childXScalar in xScalar.childXScalars) {
      NxtExecutionUnit? next2 = _findScalarNextExecutionUnitCascade(
          xScalar: childXScalar, debug: debug);
      if (next2 != null && next2.yes) {
        return next2;
      }
    }
    return null;
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

  void printInfo() {
    print("\n\n--------------------------------------------------------------");
    for (XScalar xScalar in allXScalars) {
      if (xScalar.queryHint != QueryHint.none) {
        xScalar.printInfo();
      }
    }
    for (XBlock xBlock in allRootXBlocks) {
      xBlock.printInfoCascade();
    }
    for (XBlockFormModel xBlockFormModel in allXBlockFormModels) {
      xBlockFormModel.printInfo();
    }
    print("--------------------------------------------------------------\n\n");
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
