part of '../flutter_artist.dart';

class _FrameInfoView extends StatelessWidget {
  final Frame? frame;

  const _FrameInfoView({required this.frame});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      leading: Image.asset(
        "packages/flutter_artist/static-rs/flu.png",
        width: 40,
        height: 40,
      ),
      title: Text(
        getClassName(frame),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: frame?.description == null
          ? null
          : Text(
              frame!.description!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
    );
  }
}
