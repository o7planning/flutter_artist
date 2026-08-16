import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_router/flutter_artist_router.dart';

import '_debug_box.dart';
import 'debug_style_utils.dart';

class RouteStackDebugBox extends BaseDebugBox {
  final List<RouteKey> stack;

  const RouteStackDebugBox({
    super.key,
    required this.stack,
  });

  @override
  List<Widget> getChildIconLabelTexts(BuildContext context) {
    List<Widget> list1 = stack
        .asMap()
        .entries
        .map(
          (entry) => IconLabelText(
            label: entry.key.toString(),
            text: entry.value.path,
            labelTextSpacing: 5,
            labelStyle: DebugStyleUtils.getLabelStyle0(context),
            textStyle: DebugStyleUtils.getTextStyle0(context),
          ),
        )
        .toList();
    return list1;
  }
}
