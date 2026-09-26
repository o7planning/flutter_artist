enum BlockErrorMethod {
  getItemId,
  convertItemDetailToItem,
  needToKeepItemInList,
  performQuery,
  performQueryByItemIds,
  performDeleteItemById,
  performLoadItemDetailById,
}

enum TaskErrorMethod {
  performExec,
  performLoadInitData;
}

enum StageErrorMethod {
  performLoadInitData,
  performExec,
}
