part of '../flutter_artist.dart';

abstract class _BlkOrScrCriteriaView extends StatelessWidget {
  String getBlockOrScalarClassName();

  String? getDataFilterClassName();

  String? getFilterCriteriaClassName();

  List<String> getFilterCriteriaDebugInfo();

  @override
  Widget build(BuildContext context) {
    String? dataFilterClassName = getDataFilterClassName();
    String? criteriaClassName = getFilterCriteriaClassName();
    List<String> criteriaDebugInfos = getFilterCriteriaDebugInfo();
    //
    return _CustomAppContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dataFilterClassName == null) //
            _showNoDataFilterInfo(),
          _buildCriteriaShortDocument(
            dataFilterClassName: dataFilterClassName,
            criteriaClassName: criteriaClassName,
          ),
          if (criteriaClassName != null) Divider(),
          if (criteriaClassName != null)
            Expanded(
              child: _CriteriaValuesView(
                filterCriteriaClassName: criteriaClassName,
                criteriaValueInfos: criteriaDebugInfos,
              ),
            ),
        ],
      ),
    );
  }

  Widget _showNoDataFilterInfo() {
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
