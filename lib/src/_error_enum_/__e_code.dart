part of '../../flutter_artist.dart';

enum ECode {
  busy,
  noForm,
  formInitialDataNotReady,
  notAllow,
  checkAllowMethodError,
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
}
