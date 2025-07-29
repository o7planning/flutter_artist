part of '../../_fa_core.dart';

class _InfoView extends StatelessWidget {
  final String info;

  _InfoView({required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: IconLabelText(
        icon: const Icon(
          FaIconConstants.infoIconData,
          size: 16,
        ),
        label: "",
        text: info,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
