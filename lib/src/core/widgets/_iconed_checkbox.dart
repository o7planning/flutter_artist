import 'package:flutter/material.dart';

class IconedCheckbox extends StatelessWidget {
  final Icon icon;
  final bool value;
  final Function(bool? value)? onChanged;

  const IconedCheckbox({
    super.key,
    required this.icon,
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
          icon,
        ],
      ),
    );
  }
}
