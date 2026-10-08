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
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError,
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
}
