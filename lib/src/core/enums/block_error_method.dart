part of '_enums.dart';

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
  performSubmit,
  performLoadInitData,
  convertToFormOutput;
}

enum StageErrorMethod {
  performLoadInitData,
  performExec,
}
