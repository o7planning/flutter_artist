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
  resetTaskStateInternal,
  convertToFormOutput,
  isMultipleSubmissionsAllowed,
  isReexecutionAllowed,
  onTaskCompleted;
}

enum StageErrorMethod {
  performLoadInitData,
  performSubmit,
  convertToFormOutput,
}

enum ProzessErrorMethod {
  performLoadInitData,
  isReexecutionAllowed,
  createProzessContextData,
  determineInitialStage,
  contextDataReset,
  contextDataUpdateFromActiveStage,
  resetProzessStateInternal,
  onProzessCompleted;
}
