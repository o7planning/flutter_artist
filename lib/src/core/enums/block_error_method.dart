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
  performLoadInitData,
  performSubmit,
  convertToFormOutput;
}

enum StageErrorMethod {
  performLoadInitData,
  performSubmit,
  convertToFormOutput,
}

enum ProzessErrorMethod {
  performLoadInitData,
  isStageReexecutionAllowed,
  createProzessContextData,
  determineInitialStage,
  contextDataReset,
  contextDataUpdateFromActiveStage,
}
