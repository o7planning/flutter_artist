part of '../flutter_artist.dart';

class CustomControlBarSingleItem extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Decoration? decoration;
  final Block block;
  final String? description;

  final CustomControlBarItem controlBarItem;

  ///
  /// The owner class instance.
  ///
  final Object ownerClassInstance;

  const CustomControlBarSingleItem({
    super.key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    required this.ownerClassInstance,
    this.decoration,
    required this.block,
    this.description,
    required this.controlBarItem,
  });

  @override
  Widget build(BuildContext context) {
    return CustomControlBar(
      ownerClassInstance: ownerClassInstance,
      block: block,
      startControlBarItems: [controlBarItem],
      endControlBarItems: [],
    );
  }
}
