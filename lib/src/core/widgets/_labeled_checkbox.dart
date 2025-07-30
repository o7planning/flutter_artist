import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool? value)? onChanged;
  final TextStyle? labelStyle;

  const LabeledCheckbox({
    super.key,
    required this.label,
    this.labelStyle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null
          ? null
          : () {
              onChanged!(!value);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(
            splashRadius: 0,
            value: value,
            onChanged: onChanged == null
                ? null
                : (bool? newValue) {
                    onChanged!(newValue);
                  },
          ),
          Text(
            label,
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}
