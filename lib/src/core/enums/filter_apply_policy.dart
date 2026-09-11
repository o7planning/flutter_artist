/// Defines the synchronization policy between the draft criteria in the UI workspace
/// and the applied criteria consumed by bound blocks.
enum FilterApplyPolicy {
  /// Live filtering mode.
  ///
  /// Any mutation occurring within the filter panel workspace is automatically committed
  /// as a snapshot from draft to applied state (typically debounced), immediately signaling
  /// bound blocks to refresh or transition their query lifecycle without requiring an explicit
  /// user trigger.
  instant,

  /// Manual/explicit filtering mode.
  ///
  /// Workspace mutations remain strictly isolated within the draft criteria and draft data state.
  /// The applied criteria and applied data state are only updated when an intentional command
  /// (such as pressing a search button or calling an explicit apply method) is executed.
  explicit,
}
