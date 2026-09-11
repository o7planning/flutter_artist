/// Defines the exact synchronization directive governing how a query execution
/// across a [Block] or [Scalar] reconciles its associated [FilterModel] state.
///
/// Dictates whether the active draft workspace inputs are committed, ignored,
/// reverted, or forced as a mirror snapshot before dispatching the query lifecycle.
enum FilterSyncDirective {
  /// Strictly queries using the existing committed snapshot ([FilterModel.committedFilterCriteria])
  /// without modifying or touching the active draft workspace.
  ///
  /// Any work-in-progress edits or invalid inputs on the FilterPanel remain strictly
  /// isolated in the draft realm.
  useCommitted,

  /// Commits the current draft criteria and draft data state unconditionally to the
  /// committed realm prior to query execution, mirroring the natural behavior of
  /// [FilterApplyPolicy.instant].
  ///
  /// Faithful to raw state propagation: if the draft workspace holds an error
  /// (e.g. cascade dropdown network failure), that exact error state is transferred
  /// to the committed snapshot, allowing consumer blocks to synchronously reflect
  /// the failure without masking or ghosting.
  forceCommitDraft,

  /// Conditionally commits the draft workspace snapshot to the committed realm only if
  /// the draft state is completely healthy and validated ([FilterDataStateLoaded]).
  ///
  /// If the draft workspace carries an error or is in an unresolved pending state,
  /// the commit is bypassed, and the query proceeds against the existing committed snapshot.
  commitDraftIfValid,

  /// Discards unapplied draft workspace mutations and forcefully rolls back the FilterPanel UI
  /// controls back to the previously committed criteria snapshot before executing the query.
  discardDraftToCommitted,
}
