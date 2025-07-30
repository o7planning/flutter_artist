import 'package:flutter/material.dart';

import '../../core/_core/code.dart';

class XDataView extends StatelessWidget {
  final XData? xData;

  const XDataView({
    super.key,
    required this.xData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Text(
        xData == null ? "null" : xData!.data.toString(),
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
