part of '../../flutter_artist.dart';

///
/// FilterModel with Query Options
///
class _FilterModelOpt {
  final FilterModel filterModel;
  final FilterInput? filterInput;

  _FilterModelOpt({
    required this.filterModel,
    required this.filterInput,
  }) {
    if (filterInput != null) {
      assert(filterModel.getFilterInputTypeAsString() ==
          filterInput.runtimeType.toString());
    }
  }

  @override
  String toString() {
    return "${getClassName(this)}(${getClassName(filterModel)})";
  }
}
