/// Categorizes the root architectural source or trigger layer that caused a query failure.
enum BlockErrorOrigin {
  /// The failure originated directly from this block's own remote data fetch or execution method.
  directFetch,

  /// The query was aborted because an upstream parent block in the hierarchy failed to load its data context.
  parentCascade,

  /// The query was blocked due to an evaluation or data extraction failure within the bound [FilterModel].
  filterModel;

  /// Resolves the downstream error attribution perspective when propagating
  /// this lifecycle failure down to dependent child blocks.
  ///
  /// - A direct remote query failure ([directFetch]) or an existing upstream cascade
  ///   ([parentCascade]) is mapped to [parentCascade] from the child's perspective.
  /// - A shared criteria extraction error ([filterModel]) preserves its [filterModel]
  ///   origin across the entire shared-filter subtree.
  BlockErrorOrigin toCascadedOrigin() => switch (this) {
        directFetch || parentCascade => parentCascade,
        filterModel => filterModel,
      };
}

/// Categorizes the root architectural source or trigger layer that caused a scalar query failure.
enum ScalarErrorOrigin {
  /// The failure originated directly from this scalar's own remote data fetch method.
  directFetch,

  /// The query was aborted because an upstream parent block/scalar failed to provide a valid target context.
  parentCascade,

  /// The query was blocked due to an evaluation or data extraction failure within the bound [FilterModel].
  filterModel;

  /// Resolves the downstream error attribution perspective when propagating
  /// this lifecycle failure down to dependent child scalars.
  ///
  /// - A direct remote query failure ([directFetch]) or an existing upstream cascade
  ///   ([parentCascade]) is mapped to [parentCascade] from the child's perspective.
  /// - A shared criteria extraction error ([filterModel]) preserves its [filterModel]
  ///   origin across the entire shared-filter subtree.
  ScalarErrorOrigin toCascadedOrigin() => switch (this) {
        directFetch || parentCascade => parentCascade,
        filterModel => filterModel,
      };
}
