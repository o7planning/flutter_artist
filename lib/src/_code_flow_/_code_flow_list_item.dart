part of '../../flutter_artist.dart';

class _CodeFlowListItem extends StatelessWidget {
  final _CodeFlowItem flowLogItem;
  final bool selected;

  final Function() onTap;

  const _CodeFlowListItem({
    required this.flowLogItem,
    required this.selected,
    required this.onTap,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _backgroundColor(),
      child: flowLogItem.isMethodCall()
          ? _CodeFlowMethodView(
        codeFlowItem: flowLogItem,
        selected: selected,
        textSelectable: false,
        onTap: onTap,
      )
          : _CodeFlowInfoErrorView(
        codeFlowItem: flowLogItem,
        textOverflow: TextOverflow.ellipsis,
        selected: selected,
        onTap: onTap,
      ),
    );
  }

  Color _backgroundColor() {
    return selected
        ? _selectedCodeFlowItemBgColor
        : _deselectedCodeFlowItemBgColor;
  }
}
