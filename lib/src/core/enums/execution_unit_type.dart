enum ExecutionUnitType {
  shelfQuery,
  shelfInternalReact,
  //
  storageBackendAction,
  //
  blockClearCurrentItem,
  blockDeleteItem,
  blockDeleteItems,
  blockPrepareToCreateItem,
  blockQuery,
  blockBackendAction,
  blockQuickChildBlockItems,
  blockQuickCreateItem,
  blockBackendCreateItem,
  blockQuickUpdateItem,
  blockBackendUpdateItem,
  blockSetItemAsCurrent,
  blockClear,
  //
  filterModelLoadData,
  filterModelFilterPanelChanged,
  //
  formModelPatchFormFields,
  formModelLoadData,
  formModelSaveForm,
  formModelFormViewChanged,
  //
  scalarQuery,
  scalarClear,
  scalarBackendAction,
  scalarLoadExtraData,
  //
  activity;

  String asDebugExecutionUnit([String? forName]) {
    if (forName == null) {
      return "<b>$name</b> execution unit";
    } else {
      return "<b>$name($forName)</b> execution unit";
    }
  }
}
