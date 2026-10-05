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
  // noPreviousPage,
  // noNextPage,
  // noCurrentPagination,
  //
  blockInStaleState,


  inPendingState, // State
  inErrorState, // State
  inNoneState, // State
  inStaleState, // State
  //
  // inNoneMode, // Mode. TODO: Remove.
  //
  noTarget,
  invalidTarget,
  formIsNotDirty,
  formInvalidated,
  //
  noLoggedInUser,
  permissionDenied,
  //
  cancelled,
  //
  hasActiveViews,
  hasNoActiveUI,
  taskInPendingState,
  taskAlreadySubmitted,
}
