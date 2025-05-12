part of '../../flutter_artist.dart';

Size _calculateDebugDialogSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  double width = size.width > 1000 ? 1000 - 40 : size.width - 40;
  double height = size.height > 620 ? 620 - 40 : size.height - 40;
  return Size(width, height);
}
