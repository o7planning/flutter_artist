part of '../../_fa_core.dart';

class BlockDebugStateView extends StatelessWidget {
  final Block block;
  final BlockDebugOptions? blockDebugOptions;
  final FormDebugOptions? formDebugOptions;
  final PaginationDebugOptions? paginationDebugOptions;

  final bool showTitle;
  final bool vertical;

  const BlockDebugStateView({
    super.key,
    required this.block,
    required this.vertical,
    this.showTitle = true,
    required this.blockDebugOptions,
    required this.formDebugOptions,
    required this.paginationDebugOptions,
  });

  @override
  Widget build(BuildContext context) {
    const double minBoxWidth = 200;
    return RefreshableNeutralViewBuilder(
      ownerClassInstance: this,
      description: null,
      shelves: [block.shelf],
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
                  if (showTitle) Text(block.name),
                  if (showTitle) const Divider(height: 10),
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
