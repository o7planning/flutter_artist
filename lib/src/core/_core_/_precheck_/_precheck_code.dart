part of '__precheck.dart';

enum PrecheckCode {
  busy,
  restricted,
  pageableNotSupported,
  alreadyOnFirstPage,
  alreadyOnLastPage,
  hostStateNotReadyForForm,
  noForm,
  formInNoneState,
  formInPendingState,
  formInFatalErrorState,
  formInStaleState,
  notAllowed,
  checkAllowMethodError,
  //
  queryLockedTemporarily,
  //
  blockInStaleState,
  blockInPendingState, // State
  blockInNoneState,
  //
  noTarget,
  invalidTarget,
  formIsNotDirty,
  formInvalidated,
  //
  noLoggedInUser,
  permissionDenied,
  userIsNotSystemUser,
  //
  cancelled,
  //
  hasActiveViews,
  //
  taskInPendingState,
  taskAlreadySubmitted,
  stageInPendingState,
  stageAlreadySubmitted,
  reexecutionNotAllowed,
  stageNotSubmittedYet,
  stageRestartRestricted,
  noFilterModel,
  prozessNotStarted,
  noPreviousStage,
  noNextStage,
  nextStageNotReached,
  noViewingStage,
  stageNotReady,
  formDataNotLoaded,
  // allowCheckError,
  taskNotReady,
}
