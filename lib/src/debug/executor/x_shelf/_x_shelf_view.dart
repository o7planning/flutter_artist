import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';

class XShelfView extends StatelessWidget {
  final XShelf xShelf;

  const XShelfView({
    super.key,
    required this.xShelf,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "XShelf",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Divider(),
        IconLabelText(
          label: "Type: ",
          text: xShelf.xShelfType.name,
          textStyle: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        IconLabelText(label: "Shelf: ", text: xShelf.shelf.name),
        SizedBox(height: 10),
        IconLabelText(
          label: "XShelf ID: ",
          text: xShelf.xShelfId.toString(),
          textStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
