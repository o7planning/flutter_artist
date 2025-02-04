part of '../flutter_artist.dart';

class _FilterCriteriaDebugView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;
  final DataFilter? dataFilter;

  const _FilterCriteriaDebugView.block({
    super.key,
    required Block this.block,
  })  : scalar = null,
        dataFilter = null;

  const _FilterCriteriaDebugView.scalar({
    super.key,
    required Scalar this.scalar,
  })  : block = null,
        dataFilter = null;

  const _FilterCriteriaDebugView.dataFilter({
    super.key,
    required DataFilter this.dataFilter,
  })  : block = null,
        scalar = null;

  @override
  Widget build(BuildContext context) {
    FilterCriteria? filterCriteria;
    DataFilter? dataFilterOfBlockOrScalar;
    if (block != null) {
      dataFilterOfBlockOrScalar = block!.dataFilter;
      filterCriteria = block!.data.filterCriteria;
    } else if (scalar != null) {
      dataFilterOfBlockOrScalar = scalar!.dataFilter;
      filterCriteria = scalar!.data.filterCriteria;
    } else if (dataFilterOfBlockOrScalar != null) {
      filterCriteria = dataFilter!.filterCriteria;
    } else {
      throw "TODO - FilterCriteriaView";
    }
    return _CustomAppContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dataFilterOfBlockOrScalar == null && dataFilter == null)
            _showNoDataFilterInfo_forBlockOrScalar(),
          if (dataFilterOfBlockOrScalar != null)
            _getFilterCriteriaShortInfo_ofBlockOrScalar(
              dataFilterOfBlockOrScalar: dataFilterOfBlockOrScalar,
              filterCriteria: filterCriteria,
            ),
          if (dataFilterOfBlockOrScalar != null && filterCriteria != null)
            Divider(),
          if (dataFilterOfBlockOrScalar != null && filterCriteria != null)
            Expanded(
              child: _buildFilterCriteriaData(
                filterCriteria: filterCriteria,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterCriteriaData({required FilterCriteria filterCriteria}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: "Data of "),
              TextSpan(
                text: getClassName(filterCriteria),
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: ":"),
            ],
          ),
        ),
        SizedBox(height: 5),
        SelectableText.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.normal,
            ),
            children: [
              TextSpan(text: "(This debug information is returned from the "),
              TextSpan(
                text: "getDebugInfos()",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: " method)."),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: filterCriteria
                .getDebugInfos()
                .map(
                  (line) => ListTile(
                    minLeadingWidth: 0,
                    dense: true,
                    visualDensity: VisualDensity(vertical: -3, horizontal: -3),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 14,
                    ),
                    title: Text(
                      line,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _showNoDataFilterInfo_forBlockOrScalar() {
    return SelectableText.rich(
      TextSpan(
        children: [
          if (block != null)
            TextSpan(
              text: getClassName(block),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          if (scalar != null)
            TextSpan(
              text: getClassName(scalar),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          TextSpan(text: " is using $EmptyFilterCriteria."),
        ],
      ),
    );
  }

  ///
  /// If 'block' or 'scalar' is not null.
  ///
  Widget _getFilterCriteriaShortInfo_ofBlockOrScalar({
    required DataFilter dataFilterOfBlockOrScalar,
    required FilterCriteria? filterCriteria,
  }) {
    if (filterCriteria == null) {
      return Text("filterCriteria is null");
    } else {
      return SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: getClassName(filterCriteria),
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " is used as the criteria for filtering data on "),
            if (block != null)
              TextSpan(
                text: getClassName(block),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (scalar != null)
              TextSpan(
                text: getClassName(scalar),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            TextSpan(text: ". It is created by "),
            TextSpan(
              text:
                  "${getClassName(dataFilterOfBlockOrScalar)}.createFilterCriteria()",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " and can be retrieved via "),
            if (block != null)
              TextSpan(
                text: "${getClassName(block)}.data.filterCriteria",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (scalar != null)
              TextSpan(
                text: "${getClassName(scalar)}.data.filterCriteria",
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
