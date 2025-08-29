enum AfterBlockSilentAction {
  refreshCurrentItem,
  query,
  none;
}

enum AfterScalarSilentAction {
  none,
  query;
}

enum AfterScalarLoadExtraDataQuickAction {
  none,
  // TODO: Change to updateUIComponents.
  update;
}
