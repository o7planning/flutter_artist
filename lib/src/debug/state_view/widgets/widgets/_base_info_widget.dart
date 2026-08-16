import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../../../core/enums/debug_btn_type.dart';

abstract class BaseInfoWidget extends StatelessWidget {
  final TextStyle labelStyle;
  final TextStyle textStyle;

  const BaseInfoWidget({
    super.key,
    required this.labelStyle,
    required this.textStyle,
  });

  String getLabel();

  String getText();

  String? getLeftTooltip();

  String? getButtonTooltip();

  ButtonFunction? getButtonFunction();

  @override
  Widget build(BuildContext context) {
    ButtonFunction? btnFunc = getButtonFunction();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Tooltip(
            message: getLeftTooltip() ?? "",
            child: IconLabelText(
              label: getLabel(),
              text: getText(),
              labelStyle: labelStyle,
              textStyle: textStyle,
            ),
          ),
        ),
        if (btnFunc != null)
          SimpleSmallIconButton(
            iconData: DebugBtnType.getIconData(btnFunc.btnType),
            iconSize: 14,
            iconColor: btnFunc.btnType.getColor(context),
            onPressed: () {
              btnFunc.onPressed(context);
            },
          ),
      ],
    );
  }
}

class ButtonFunction {
  final DebugBtnType btnType;
  final Function(BuildContext context) onPressed;

  ButtonFunction({required this.btnType, required this.onPressed});
}
