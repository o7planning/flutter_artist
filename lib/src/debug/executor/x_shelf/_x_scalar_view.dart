import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';

class XScalarView extends StatelessWidget {
  final XScalar xScalar;

  const XScalarView({
    super.key,
    required this.xScalar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "XBlock",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          "(${xScalar.xShelf.xShelfType.name} - XShelfID: ${xScalar.xShelf.xShelfId})",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Divider(),
        IconLabelText(label: "Scalar: ", text: xScalar.scalar.name),
        SizedBox(height: 10),
        IconLabelText(
          label: "Query Hint: ",
          text: xScalar.queryHint.name,
          textStyle: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
