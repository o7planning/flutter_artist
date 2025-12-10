import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/_core_/core.dart';
import '../dialog/_error_viewer_dialog.dart';
import '__task_flow_const.dart';

class MasterFlowItemBox extends StatelessWidget {
  final MasterFlowItem masterFlowItem;
  final bool selected;
  final Function() onTap;

  const MasterFlowItemBox({
    required this.masterFlowItem,
    required this.selected,
    required this.onTap,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected
          ? CodeFlowConstants.selectedMasterFlowItemBgColor
          : CodeFlowConstants.deselectedMasterFlowItemBgColor,
      child: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5,
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: -3,
        vertical: -3,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      leading: _buildLeading(),
      trailing: Text(
        masterFlowItem.id.toString(),
        style: TextStyle(
          color: Colors.black45,
          fontSize: 9,
        ),
      ),
      title: _buildTitle(context),
      subtitle: _buildSubTitle(),
      onTap: onTap,
    );
  }

  Widget _buildLeading() {
    bool error = masterFlowItem.hasError();
    return Tooltip(
      message: masterFlowItem.masterFlowItemType.getTooltipText(),
      child: Icon(
        masterFlowItem.masterFlowItemType.getIconData(),
        color: masterFlowItem.masterFlowItemType.getIconColor(error),
        size: 18,
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTitle(BuildContext context) {
    ErrorInfo? errorInfo = masterFlowItem.getErrorInfo();
    bool hasEvent = masterFlowItem.hasEvent();
    return IconLabelText(
      text: masterFlowItem.getTitle(),
      style: _titleStyle(),
      suffixIcon: hasEvent
          ? Tooltip(
              message: "There was an event broadcast here.",
              child: Icon(
                Icons.electric_bolt_outlined,
                color: Colors.deepOrangeAccent,
                size: 14,
              ),
            )
          : null,
      suffixIcon2: errorInfo != null
          ? SimpleSmallIconButton(
              iconData: Icons.error_outline,
              iconColor: Colors.red,
              iconSize: 14,
              onPressed: () {
                _showErrorDialog(context, errorInfo);
              },
            )
          : null,
    );
  }

  Widget _buildSubTitle() {
    return Text(masterFlowItem.getSubtitle(), style: _subtitleStyle());
  }

  void _showErrorDialog(BuildContext context, ErrorInfo errorInfo) {
    ErrorViewerDialog.showErrorViewerDialog(
      context: context,
      title: "Error Viewer",
      errorInfo: errorInfo,
    );
  }
}
