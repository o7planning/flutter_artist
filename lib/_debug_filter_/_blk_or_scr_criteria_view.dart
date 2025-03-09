part of '../flutter_artist.dart';

abstract class _BlkOrScrCriteriaView extends StatelessWidget {
  String getBlockOrScalarClassName();

  String? getFilterModelClassName();

  FilterCriteria? getFilterCriteria();

  // String? getFilterCriteriaClassName();
  //
  // List<String> getFilterCriteriaDebugInfo();

  @override
  Widget build(BuildContext context) {
    String? dataFilterClassName = getFilterModelClassName();
    FilterCriteria? filterCriteria = getFilterCriteria();
    String? criteriaClassName =
        filterCriteria == null ? null : getClassName(filterCriteria);
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dataFilterClassName == null) //
            _showNoFilterModelInfo(),
          _buildCriteriaShortDocument(
            dataFilterClassName: dataFilterClassName,
            criteriaClassName: criteriaClassName,
          ),
          if (criteriaClassName != null) Divider(),
          if (filterCriteria != null)
            _CriteriaValuesView(
              filterCriteria: filterCriteria,
              filterCriteriaPath:
                  "${getBlockOrScalarClassName()}.data.filterCriteria",
            ),
        ],
      ),
    );
  }

  Widget _showNoFilterModelInfo() {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: getBlockOrScalarClassName(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " is using $EmptyFilterCriteria."),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String? dataFilterClassName,
    required String? criteriaClassName,
  }) {
    if (criteriaClassName == null) {
      return Text("filterCriteria is null");
    } else {
      return SelectableText.rich(
        style: TextStyle(fontSize: _debugFontSize),
        TextSpan(
          children: [
            TextSpan(
              text: criteriaClassName,
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " is used as the criteria for filtering data on "),
            TextSpan(
              text: getBlockOrScalarClassName(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ". It is created by "),
            TextSpan(
              text: "$dataFilterClassName.createFilterCriteria()",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " and can be retrieved via "),
            TextSpan(
              text: "${getBlockOrScalarClassName()}.data.filterCriteria",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " property."),
          ],
        ),
      );
    }
  }
}
