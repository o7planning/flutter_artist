part of '../flutter_artist.dart';

class _LabeledRadio<E> extends StatelessWidget {
  final String label;
  final E value;
  final E? groupValue;
  final Function(E? value)? onChanged;
  final TextStyle? labelStyle;

  const _LabeledRadio({
    super.key,
    required this.label,
    this.labelStyle,
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
          Text(
            label,
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}
