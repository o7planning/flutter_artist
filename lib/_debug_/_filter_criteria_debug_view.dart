part of '../flutter_artist.dart';

class _FilterCriteriaDebugView extends StatelessWidget {
  final Block? block;
  final Scalar? scalar;

  const _FilterCriteriaDebugView.block({
    super.key,
    required Block this.block,
  }) : scalar = null;

  const _FilterCriteriaDebugView.scalar({
    super.key,
    required Scalar this.scalar,
  }) : block = null;

  @override
  Widget build(BuildContext context) {
    FilterCriteria? filterCriteria;
    DataFilter? dataFilter;
    if (block != null) {
      dataFilter = block!.dataFilter;
      filterCriteria = block!.data.filterCriteria;
    } else if (scalar != null) {
      dataFilter = scalar!.dataFilter;
      filterCriteria = scalar!.data.filterCriteria;
    } else {
      throw "TODO - FilterCriteriaView";
    }
    return _CustomAppContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dataFilter == null) _showNoDataFilterInfo(),
          if (dataFilter != null)
            _getFilterCriteriaShortInfo(
              dataFilter: dataFilter,
              filterCriteria: filterCriteria,
            ),
          if (dataFilter != null && filterCriteria != null) Divider(),
          if (dataFilter != null && filterCriteria != null)
            _buildFilterCriteriaData(
              filterCriteria: filterCriteria,
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
              TextSpan(text: "."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _showNoDataFilterInfo() {
    return SelectableText.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              _filterCriteriaDebugIconData,
              size: 16,
            ),
          ),
          TextSpan(text: " "),
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
          TextSpan(text: " has no DataFilter."),
        ],
      ),
    );
  }

  Widget _getFilterCriteriaShortInfo({
    required DataFilter dataFilter,
    required FilterCriteria? filterCriteria,
  }) {
    if (filterCriteria == null) {
      return Text("filterCriteria is null");
    } else {
      return SelectableText.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                _filterCriteriaDebugIconData,
                size: 16,
              ),
            ),
            TextSpan(text: " "),
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
              text: "${getClassName(dataFilter)}.createFilterCriteria()",
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
