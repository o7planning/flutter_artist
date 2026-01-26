import '../_core_/core.dart';
import '../utils/_string_utils.dart';

///
/// An empty or null searchText is considered the same.
///
class SearchTextFilterCriteria extends FilterCriteria {
  final String? searchText;

  SearchTextFilterCriteria({
    required this.searchText,
  });

  @override
  List<Criterionable> registerSupportedCriteria() {
    return [
      Criterionable<String>(
        criterionBaseName: 'searchText',
        jsonCriterionName: 'searchText',
        converter: (String? baseValue) {
          return SimpleVal.ofString(baseValue);
        },
      ),
    ];
  }

  @override
  List<String> getDebugCriterionInfos() {
    return ["searchText: $searchText"];
  }

  @override
  List<Object?> get props => [StrUtils.stringToNullIfEmpty(searchText)];
}
