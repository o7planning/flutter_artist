/// Sub-state specifically when [DataState] is [pending].
enum PendingReason {
  /// First time loading, no error yet
  initial,

  /// Loading failed, still no data available
  fetchFailed;
}
