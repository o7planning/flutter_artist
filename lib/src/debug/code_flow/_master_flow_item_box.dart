import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../../flutter_artist.dart';
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
      fontWeight: masterFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _subtitleStyle() {
    return TextStyle(
      fontSize: 11,
      fontWeight: masterFlowItem.isPublicMethodCall()
          ? FontWeight.bold
          : FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTitle(BuildContext context) {
    String title;
    switch (masterFlowItem.masterFlowItemType) {
      case MasterFlowItemType.taskCall:
        title = masterFlowItem.taskType?.name ?? "";
      case MasterFlowItemType.methodCall:
        title = ".${masterFlowItem.funcCallInfo?.funcName}()";
    }
    ErrorInfo? errorInfo = masterFlowItem.getErrorInfo();
    return IconLabelText(
      text: title,
      style: _titleStyle(),
      suffixIcon: errorInfo != null
          ? SimpleSmallIconButton(
              iconData: Icons.error_outline,
              iconColor: Colors.red,
              onPressed: () {
                _showErrorDialog(context, errorInfo);
              },
            )
          : null,
    );
  }

  Widget _buildSubTitle() {
    String subtitle;
    switch (masterFlowItem.masterFlowItemType) {
      case MasterFlowItemType.taskCall:
        subtitle =
            "${getClassNameWithoutGenerics(masterFlowItem.ownerClassInstance)} - (${masterFlowItem.lineFlowItems.length})";
      case MasterFlowItemType.methodCall:
        subtitle =
            getClassNameWithoutGenerics(masterFlowItem.ownerClassInstance);
    }
    return Text(subtitle, style: _subtitleStyle());
  }

  void _showErrorDialog(BuildContext context, ErrorInfo errorInfo) {
    ErrorViewerDialog.showErrorViewerDialog(
      context: context,
      title: "Error Viewer",
      errorInfo: errorInfo,
    );
  }
}
