import 'package:flutter/material.dart';

class IconedRadio<E> extends StatelessWidget {
  final Icon icon;
  final E value;
  final E? groupValue;
  final Function(E? value)? onChanged;

  const IconedRadio({
    super.key,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null
          ? null
          : () {
              onChanged!(value);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Radio<E>(
            splashRadius: 0,
            value: value,
            onChanged: onChanged == null
                ? null
                : (E? newValue) {
                    onChanged!(newValue);
                  },
            groupValue: groupValue,
          ),
          icon,
        ],
      ),
    );
  }
}
