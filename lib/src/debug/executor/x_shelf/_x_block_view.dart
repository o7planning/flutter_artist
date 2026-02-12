import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../core/_core_/core.dart';

class XBlockView extends StatelessWidget {
  final XBlock xBlock;

  const XBlockView({
    super.key,
    required this.xBlock,
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
          "(${xBlock.xShelf.xShelfType.name} - XShelfID: ${xBlock.xShelf.xShelfId})",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Divider(),
        IconLabelText(label: "Block: ", text: xBlock.block.name),
        SizedBox(height: 10),
        IconLabelText(
          label: "Query Hint: ",
          text: xBlock.queryHint.name,
          textStyle: TextStyle(color: Colors.red),
        ),
        SizedBox(height: 10),
        IconLabelText(
          label: "Refresh Current Item: ",
          text: xBlock.forceReloadCurrItem.toString(),
          textStyle: TextStyle(color: Colors.red),
        ),
        Divider(),
        IconLabelText(
          label: "Query Type: ",
          text: xBlock.queryType.name,
        ),
        SizedBox(height: 10),
        IconLabelText(
          label: "List Behavior: ",
          text: xBlock.listUpdateStrategy.name,
        ),
        SizedBox(height: 10),
        IconLabelText(
          label: "After Query Action: ",
          text: xBlock.afterQueryAction.name,
        ),
        SizedBox(height: 10),
        IconLabelText(
          label: "Pageable: ",
          text: xBlock.pageable.toString(),
        ),
      ],
    );
  }
}
