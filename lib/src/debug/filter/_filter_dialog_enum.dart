enum FilterViewType {
  debugFilterModel,
  debugFilterCriteria,
  debugShelfStructure;

  String get title {
    switch (this) {
      case FilterViewType.debugFilterModel:
        return "Debug Filter Model Viewer";
      case FilterViewType.debugFilterCriteria:
        return "Debug Filter Criteria Viewer";
      case FilterViewType.debugShelfStructure:
        return "Debug Shelf Structure Viewer";
    }
  }
}
