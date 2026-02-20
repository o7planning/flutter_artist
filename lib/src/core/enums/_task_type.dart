enum TaskType {
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
  blockQuickMultiItemCreation,
  blockQuickUpdateItem,
  blockBackendUpdateItem,
  blockSetItemAsCurrent,
  blockClearance,
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
  scalarClearance,
  scalarBackendAction,
  scalarLoadExtraData,
  //
  hook,
  activity;

  String asDebugTaskUnit([String? forName]) {
    if (forName == null) {
      return "<b>$name</b> task unit";
    } else {
      return "<b>$name($forName)</b> task unit";
    }
  }
}
