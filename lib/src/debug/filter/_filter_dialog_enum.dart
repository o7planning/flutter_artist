enum FilterViewType {
  debugFilterModel,
  debugFilterCriteria,
  debugShelfStructure;

  String get title {
    switch (this) {
      case FilterViewType.debugFilterModel:
        return "Debug Filter Model Inspector";
      case FilterViewType.debugFilterCriteria:
        return "Debug Filter Criteria Inspector";
      case FilterViewType.debugShelfStructure:
        return "Debug Shelf Structure Inspector";
    }
  }
}
