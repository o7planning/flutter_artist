part of '../../flutter_artist.dart';

class _FilterModelCriteriaView extends StatelessWidget {
  final FilterModel filterModel;

  const _FilterModelCriteriaView({required this.filterModel});

  @override
  Widget build(BuildContext context) {
    String filterModelClassName = getClassName(filterModel);
    String criteriaClassName = filterModel.getFilterCriteriaType().toString();
    FilterCriteria? filterCriteria = filterModel.filterCriteria;
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCriteriaShortDocument(
            filterModelClassName: filterModelClassName,
            criteriaClassName: criteriaClassName,
          ),
          _BlocksScalarsView(
            filterModel: filterModel,
          ),
          Divider(),
          _CriteriaValuesView(
            filterCriteria: filterCriteria,
            filterCriteriaPath: "$filterModelClassName.filterCriteria",
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaShortDocument({
    required String filterModelClassName,
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
            text: "$filterModelClassName.toFilterCriteriaObject()",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " method, and can be retrieved via the "),
          TextSpan(
            text: "$filterModelClassName.filterCriteria",
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
