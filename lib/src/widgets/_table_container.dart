

import 'package:flutter/material.dart';

class TableContainer extends StatelessWidget {
  final List<double> flexes;
  final List<Widget> widgets;
  final EdgeInsets padding;

  const TableContainer({
    super.key,
    required this.flexes,
    required this.widgets,
    this.padding = const EdgeInsets.all(8),
  }) : assert(flexes.length == widgets.length);

  Map<int, TableColumnWidth> _columnWidths() {
    Map<int, double> mapFlex = flexes.asMap();
    Map<int, TableColumnWidth> map =
        mapFlex.map((k, v) => MapEntry(k, FlexColumnWidth(v)));
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Table(
        columnWidths: _columnWidths(),
        children: [
          TableRow(
            children: widgets
                .map(
                  (w) => TableCell(
                    verticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    child: w,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
