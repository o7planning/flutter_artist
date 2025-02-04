part of '../flutter_artist.dart';

class _DataFilterCriteriaView extends StatelessWidget {
  final DataFilter dataFilter;

  const _DataFilterCriteriaView({required this.dataFilter});

  @override
  Widget build(BuildContext context) {
    String dataFilterClassName = getClassName(dataFilter);
    String criteriaClassName = dataFilter.getFilterCriteriaTypeAsString();
    FilterCriteria? filterCriteria = dataFilter.filterCriteria;
    List<String> criteriaDebugInfos = filterCriteria?.getDebugInfos() ?? [];
    //
    return _CustomAppContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  Widget _buildCriteriaShortDocument({
    required String dataFilterClassName,
    required String criteriaClassName,
  }) {
    return SelectableText.rich(
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
          TextSpan(text: " is created by the "),
          TextSpan(
            text: "$dataFilterClassName.createFilterCriteria()",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: "method, and can be retrieved via the "),
          TextSpan(
            text: "$dataFilterClassName.filterCriteria",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text:
                  " property. It is used to query the following blocks and scales:"),
          // TextSpan(
          //   text: "${getBlockOrScalarClassName()}.data.filterCriteria",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
    );
  }
}
