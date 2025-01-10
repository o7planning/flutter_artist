part of '../flutter_artist.dart';

class _ShelfInfoView extends StatelessWidget {
  final Shelf? shelf;

  const _ShelfInfoView({required this.shelf});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      leading: Image.asset(
        "packages/flutter_artist/static-rs/shelf.png",
        width: 40,
        height: 40,
      ),
      title: Text(
        getClassName(shelf),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: shelf?.description == null
          ? null
          : Text(
              shelf!.description!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
    );
  }
}
