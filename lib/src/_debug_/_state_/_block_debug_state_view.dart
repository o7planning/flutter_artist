part of '../../../flutter_artist.dart';

class BlockDebugStateView extends StatelessWidget {
  final String blockName;
  final Shelf shelf;
  final BlockDebugOptions? blockDebugOptions;
  final FormDebugOptions? formDebugOptions;
  final PaginationDebugOptions? paginationDebugOptions;

  final bool vertical;

  const BlockDebugStateView({
    super.key,
    required this.shelf,
    required this.blockName,
    required this.vertical,
    this.blockDebugOptions = const BlockDebugOptions(),
    this.formDebugOptions = const FormDebugOptions(),
    this.paginationDebugOptions = const PaginationDebugOptions(),
  });

  @override
  Widget build(BuildContext context) {
    const double fontSize = 11.5;
    Block block = shelf.findBlock(blockName)!;

    var labelStyle0 = const TextStyle(
      color: Colors.indigo,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );

    var textStyle0 = const TextStyle(
      color: Colors.deepOrange,
      fontSize: fontSize,
    );

    var labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    var textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    const double minBoxWidth = 200;

    return ShelvesSafeLayoutArea(
      ownerClassInstance: this,
      description: null,
      shelves: [shelf],
      build: () {
        List<Widget> children = [];
        if (blockDebugOptions != null) {
          children.add(
            _BlockDebugBox(
              block: block,
              options: blockDebugOptions!,
            ),
          );
        }
        if (formDebugOptions != null && block.formModel != null) {
          children.add(
            _FormDebugBox(
              formModel: block.formModel!,
              options: formDebugOptions!,
            ),
          );
        }
        if (paginationDebugOptions != null) {
          children.add(
            _PaginationDebugBox(
              block: block,
              options: paginationDebugOptions!,
            ),
          );
        }
        //
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.greenAccent.withAlpha(20),
              border: Border.all(width: 0.5)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int boxCount = children.length;
              //
              Widget mainWidget;
              if (vertical || boxCount <= 1) {
                mainWidget = _buildWithColumn(children);
              } else {
                if (boxCount == 3) {
                  if (constraints.constrainWidth() > 3 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithColumnAndTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
                  }
                } else if (boxCount == 2) {
                  if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
                  }
                } else {
                  // Never run:
                  mainWidget = SizedBox();
                }
              }
              //
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(block.name),
                  const Divider(height: 10),
                  mainWidget,
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWithColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.length <= 1
          ? children
          : (children
              .expand(
                (w) => [w, SizedBox(height: 5)],
              )
              .toList()
            ..removeLast()),
    );
  }

  Widget _buildWithTableContainer(List<Widget> children) {
    return _TableContainer(
      flexes: children.map((child) => 1.0).toList(),
      padding: EdgeInsets.zero,
      widgets: children,
    );
  }

  Widget _buildWithColumnAndTableContainer(List<Widget> children) {
    assert(children.length == 3);
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableContainer(
          flexes: [1, 1],
          padding: EdgeInsets.zero,
          widgets: [children[0], children[1]],
        ),
        SizedBox(height: 5),
        children[2],
      ],
    );
  }
}
