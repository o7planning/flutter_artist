part of '_enums.dart';

enum XShelfType {
  naturalQuery,
  blockQuery,
  blockQueryEmpty,
  blockQueryAndPrepareToCreate,
  blockQueryAndPrepareToEdit,
  blockPrepareFormToCreateItem,
  blockCurrItemClear,
  blockClearItems,
  blockItemDeletion,
  blockMultiItemDeletion,
  blockCurrItemSelection,
  blockBackendActionExecution,
  blockQuickItemCreation,
  blockQuickItemUpdate,
  //
  shelfExternalReaction,
  //
  filterModelQuery,
  formModelSave,
  formModelPatchFormFields,
  formViewChange,
  filterPanelChange,
  //
  scalarQuery,
  scalarClear,
  scalarBackendAction,
  scalarQuickExtraDataLoadAction;
}
