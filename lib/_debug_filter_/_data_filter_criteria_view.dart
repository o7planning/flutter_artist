part of '../flutter_artist.dart';

class _DataFilterCriteriaView extends StatelessWidget {
  final DataFilter dataFilter;

  const _DataFilterCriteriaView({required this.dataFilter});

  @override
  Widget build(BuildContext context) {
    String dataFilterClassName = getClassName(dataFilter);
    String criteriaClassName = dataFilter.getFilterCriteriaTypeAsString();
    FilterCriteria? filterCriteria = dataFilter.filterCriteria;
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            dataFilterClassName: dataFilterClassName,
            criteriaClassName: criteriaClassName,
          ),
          _BlocksScalarsView(
            dataFilter: dataFilter,
          ),
          Divider(),
          _CriteriaValuesView(
            filterCriteria: filterCriteria,
            filterCriteriaPath: "$dataFilterClassName.filterCriteria",
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String dataFilterClassName,
    required String criteriaClassName,
  }) {
    return SelectableText.rich(
      style: TextStyle(fontSize: _debugFontSize),
      TextSpan(
        children: [
          TextSpan(text: "The "),
          TextSpan(
            text: criteriaClassName,
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " object is created by the "),
          TextSpan(
            text: "$dataFilterClassName.createFilterCriteria()",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " method, and can be retrieved via the "),
          TextSpan(
            text: "$dataFilterClassName.filterCriteria",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text:
                  " property. It is used as criteria to query data on the following blocks and scales:"),
        ],
      ),
    );
  }
}
