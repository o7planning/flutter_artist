part of '_enums.dart';

enum BlockControlBarItemType {
  back,
  refresh,
  query,
  create,
  edit,
  save,
  delete,
  reset,
  custom,
  divider,
  debugFilter,
  debugForm,
}

enum ScalarControlBarItemType {
  back,
  query,
  custom,
  divider,
  debugFilter,
}

enum FilterControlBarItemType {
  back,
  divider,
  custom,
  debugFilter,
}

enum TaskControlBarItemType {
  back,
  loadInitData,
  submit,
  divider,
  debugForm,
  custom,
}

enum ProzessControlBarItemType {
  back,
  cancel,
  restartProzess, // Restart Prozess
  restartViewingStage, // Restart Viewing Stage
  submitViewingStage, // Submit Viewing Stage
  debugInspector,
  debugViewingStageForm, //
  divider,
  moveToNextStage,
  moveToPreviousStage,
  custom,
}
