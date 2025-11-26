enum TaskType {
  shelfQuery,
  shelfInternalReact,
  //
  blockClearCurrentItem,
  blockDeleteItem,
  blockDeleteItems,
  blockPrepareToCreateItem,
  blockQuery,
  blockSilentAction,
  blockQuickChildBlockItems,
  blockQuickCreateItem,
  blockSilentCreateItem,
  blockQuickCreateMultiItems,
  blockQuickUpdateItem,
  blockSilentUpdateItem,
  blockSetItemAsCurrent,
  blockClearance,
  //
  filterModelLoadData,
  filterModelFilterPanelChanged,
  //
  formModelEnterFormFields,
  formModelLoadData,
  formModelSaveForm,
  formModelFormViewChanged,
  //
  scalarQuery,
  scalarClearance,
  scalarSilentAction;

  String asDebugTaskUnit() {
    return "<b>$name</b> task unit";
  }
}
