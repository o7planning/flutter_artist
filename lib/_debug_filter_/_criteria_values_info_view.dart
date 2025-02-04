part of '../flutter_artist.dart';

class _CriteriaValuesView extends StatelessWidget {
  final String filterCriteriaPath;
  final List<String> criteriaValueInfos;

  const _CriteriaValuesView({
    required this.filterCriteriaPath,
    required this.criteriaValueInfos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: "Data of "),
              TextSpan(
                text: filterCriteriaPath,
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
            children: criteriaValueInfos
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
}
