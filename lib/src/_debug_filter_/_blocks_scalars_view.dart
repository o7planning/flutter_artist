part of '../../flutter_artist.dart';

class _BlocksScalarsView extends StatelessWidget {
  final FilterModel filterModel;

  const _BlocksScalarsView({
    required this.filterModel,
  });

  Widget _buildItem({
    required IconData iconData,
    required String blockOrScalarClassName,
    required DataState dataState,
  }) {
    return Card(
      child: ListTile(
        minLeadingWidth: 0,
        dense: true,
        visualDensity: VisualDensity(vertical: -3, horizontal: -3),
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          iconData,
          size: 16,
        ),
        title: Text(
          blockOrScalarClassName,
          style: TextStyle(fontSize: _debugFontSize),
        ),
        trailing: Tooltip(
          message: "Data State: ${dataState.name}",
          child: Icon(
            dataState.iconData,
            color: dataState.color,
            size: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...filterModel.blocks.map(
          (block) => _buildItem(
            iconData: _blockIconData,
            blockOrScalarClassName: getClassName(block),
            dataState: block.queryDataState,
          ),
        ),
        ...filterModel.scalars.map(
          (scalar) => _buildItem(
            iconData: _scalarIconData,
            blockOrScalarClassName: getClassName(scalar),
            dataState: scalar.queryDataState,
          ),
        ),
      ],
    );
  }
}
