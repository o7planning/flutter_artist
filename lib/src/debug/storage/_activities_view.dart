import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_html_selectable_rich_text.dart';

class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ActivitiesViewState();
  }
}

class _ActivitiesViewState extends State<ActivitiesView> {
  String _getExtraInfoText(List<String> list) {
    int i = 1;
    return list
        .map((s) => "${(i++).toString().padLeft(3, '0')} - $s")
        .join("\n");
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = FlutterArtist.debugRegister.debugRegisterActivities
      ..sort();
    //
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: HtmlSelectableRichText(
            _getExtraInfoText(list),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tagStyles: {
              'b': TextStyle(fontWeight: FontWeight.bold),
              'i': TextStyle(fontStyle: FontStyle.italic),
            },
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
