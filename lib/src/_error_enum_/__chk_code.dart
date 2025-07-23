part of '../../flutter_artist.dart';

enum ChkCode {
  busy,
  noForm,
  formInitialDataNotReady,
  notAllow,
  checkAllowMethodError,
  //
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
