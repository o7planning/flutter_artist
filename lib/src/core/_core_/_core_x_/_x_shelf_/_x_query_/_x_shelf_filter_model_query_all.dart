part of '../../../core.dart';

class _XShelfFilterModelQueryAll extends XShelf {
  _XShelfFilterModelQueryAll({
    required FilterModel filterModel,
    required FilterInput? filterInput,
  }) : super(
          xShelfType: XShelfType.filterModelQueryAll,
          shelf: filterModel.shelf,
        ) {
    final queryHintForce = QryHint.force;
    final forceReloadItem = false;
    //
    final thisXFilterModel = xFilterModelMap[filterModel.name]!;
    thisXFilterModel.filterInput = filterInput;
    //
    for (XBlock xBlock in thisXFilterModel.xBlocks) {
      xBlock.setQueryHint(queryHintForce);
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
        final hasXActiveUI = parentXBlock.block.ui.hasActiveBlockFragment(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (parentXBlock.block.dataState == DataState.pending ||
              parentXBlock.block.dataState == DataState.error) {
            parentXBlock.setQueryHint(queryHintForce);
          }
        }
        // TODO: Need? Remove this code?
        XFormModel? parentXFormModel = parentXBlock.xFormModel;
        if (parentXFormModel != null &&
            parentXFormModel.formModel.ui.hasActiveUIComponent()) {
          if (parentXFormModel.formModel.dataState == DataState.pending ||
              parentXFormModel.formModel.dataState == DataState.error ||
              parentXFormModel.formModel.dataState == DataState.none) {
            parentXFormModel.setForceType(ForceType.decidedAtRuntime);
          }
        }
        //
        parentXBlock = parentXBlock.parentXBlock;
      }
    }
    for (XScalar xScalar in thisXFilterModel.xScalars) {
      xScalar.setQueryHint(queryHintForce);
      //
      XScalar? parentXScalar = xScalar.parentXScalar;
      while (true) {
        if (parentXScalar == null) {
          break;
        }
        //
        final hasXActiveUI = parentXScalar.scalar.ui.hasActiveScalarFragment(
          alsoCheckChildren: true,
        );
        if (hasXActiveUI) {
          if (parentXScalar.scalar.dataState == DataState.pending ||
              parentXScalar.scalar.dataState == DataState.error) {
            parentXScalar.setQueryHint(queryHintForce);
          }
        }
        //
        parentXScalar = parentXScalar.parentXScalar;
      }
    }
  }
}
