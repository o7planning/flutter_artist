part of '__precheck.dart';

enum PrecheckCode {
  busy,
  pageableNotSupported,
  alreadyOnFirstPage,
  alreadyOnLastPage,
  hostStateNotReadyForForm,
  noForm,
  formInNoneState,
  formInPendingState,
  formInFatalErrorState,
  formInStaleState,
  notAllow,
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
}
