/// Represents the origin of a [DataState.error] state in a Block.
enum BlockErrorOrigin {
  /// The error occurred while trying to initialize baseline data from [DataState.pending].
  /// Equivalent to [DataState.pending] for query resolution.
  fromPending,

  /// The error occurred during a background re-query while the block was in [DataState.ready].
  /// Equivalent to [DataState.ready] for query resolution (retains baseline data).
  fromReady,
}
