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
