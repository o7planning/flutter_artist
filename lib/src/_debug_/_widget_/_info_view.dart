part of '../../../flutter_artist.dart';

class _InfoView extends StatelessWidget {
  final String info;

  _InfoView({required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: _IconLabelText(
        icon: const Icon(
          _infoIconData,
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
