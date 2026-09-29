part of '_enums.dart';

enum AfterBlockBackendAction {
  query,
  none;
}

enum AfterStorageBackendAction {
  none,
  query;
}

enum AfterScalarLoadExtraDataQuickAction {
  none,
  // TODO: Change to updateUiComponents.
  update;
}
