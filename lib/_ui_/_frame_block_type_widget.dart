part of '../flutter_artist.dart';

class _FrameBlockTypeWidget extends StatelessWidget {
  final Function()? onTap;
  final FrameBlockType frameBlockType;
  final bool isListener;
  final bool isNotifier;

  const _FrameBlockTypeWidget({
    required this.onTap,
    required this.frameBlockType,
    required this.isListener,
    required this.isNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 0,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        horizontalTitleGap: 10,
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        leading: Icon(
          isListener ? _listenerIconData : _changeSourceIconData,
          size: 16,
          color: isListener ? _listenerColor : _notifierColor,
        ),
        title: BreadCrumb(
          divider: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              _breadcrumbIconData,
              size: 16,
            ),
          ),
          items: [
            BreadCrumbItem(
              content: _buildFlu(),
            ),
            BreadCrumbItem(
              content: _buildBlock(),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFlu() {
    Frame? frame = FlutterArtist._findFrame(frameBlockType.frameType);
    String? frameName = frame?.name;
    String? description = frame?.description;

    Widget w = Text(
      frameName ?? " - ",
      style: const TextStyle(fontSize: 12),
    );
    return description == null
        ? w
        : Tooltip(
            message: description,
            child: w,
          );
  }

  Widget _buildBlock() {
    return Text(
      frameBlockType.blockType.toString(),
      style: const TextStyle(fontSize: 12),
    );
  }
}
