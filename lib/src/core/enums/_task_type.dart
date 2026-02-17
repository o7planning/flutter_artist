enum TaskType {
  shelfQuery,
  shelfInternalReact,
  //
  storageSilentAction,
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
  blockBulkItemsCreation,
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
  scalarSilentAction,
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
