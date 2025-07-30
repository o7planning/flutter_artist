enum ChkCode {
  busy,
  noForm,
  formInitialDataNotReady,
  notAllow,
  checkAllowMethodError,
  //
  @Deprecated("Xoa di, thay the bang cach khac")
  filterError,
  queryLockedTemporarily,
  noPreviousPage,
  noNextPage,
  noCurrentPagination,
  //
  inPendingState, // State
  inErrorState, // State
  inNoneState, // State
  //
  inNoneMode, // Mode
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
  hasActiveUI,
  hasNoActiveUI,
}
