import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_show_mode.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';

class UiComponentsDialog extends StatefulWidget {
  final Shelf? shelf;
  final Block? block;
  final bool showActiveOnly;

  const UiComponentsDialog.block({
    required Block this.block,
    this.showActiveOnly = true,
    super.key,
  }) : shelf = null;

  const UiComponentsDialog.shelf({
    required Shelf this.shelf,
    this.showActiveOnly = true,
    super.key,
  }) : block = null;

  @override
  State<StatefulWidget> createState() {
    return _UiComponentsDialogState();
  }

  static Future<void> showActiveUIComponentsDialog({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UiComponentsDialog.shelf(
          shelf: shelf,
        );
      },
    );
  }
}

class _UiComponentsDialogState extends State<UiComponentsDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.shelf != null) {
      return "Active UI Components in current screen";
    } else if (widget.block != null) {
      return "Mounted UI Components of the Block";
    } else {
      throw UnimplementedError();
    }
  }

  Map<IRefreshableWidgetState, XState> _findWidgetStates() {
    if (widget.shelf != null) {
      return widget.shelf!.ui.debugFindMountedWidgetStates(
        activeOnly: true,
        withPagination: true,
        withBlockFragment: true,
        withFilter: true,
        withForm: true,
        withControlBar: true,
        withControl: true,
      );
    } else if (widget.block != null) {
      return widget.block!.ui.debugFindMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withBlockFragment: true,
        withFilter: true,
        withForm: true,
        withControlBar: true,
        withControl: true,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      titleText: _title(),
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (width > 520) {
      width = 500;
    } else {
      width = 0.9 * width;
    }
    if (height > 420) {
      height = 320;
    } else {
      height = height - 60;
    }
    //
    Map<IRefreshableWidgetState, XState> widgetStates = _findWidgetStates();
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.block != null)
            IconLabelText(
              label: "Block: ",
              text: "${getClassName(widget.block)} (${widget.block!.name})",
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                ...widgetStates.entries.map(
                  (entry) => _buildRowInfo(
                    widgetStateEntry: entry,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo({
    required MapEntry<IRefreshableWidgetState, XState> widgetStateEntry,
  }) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: CheckboxListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -3, horizontal: -3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        controlAffinity: ListTileControlAffinity.trailing,
        value: widgetStateEntry.key.showMode == ShowMode.dev,
        secondary: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            color: widgetStateEntry.value.isShowing
                ? Colors.green.withAlpha(30)
                : Colors.grey[200],
          ),
          child: Icon(
            widgetStateEntry.key.type.iconData,
            size: 24,
          ),
        ),
        title: IconLabelText(
          icon: const Icon(
            FaIconConstants.locationIconData,
            size: 16,
          ),
          label: "",
          text: widgetStateEntry.key.locationInfo,
          style: const TextStyle(
            fontSize: fontSize,
          ),
        ),
        subtitle: IconLabelText(
          label: '  ',
          text: widgetStateEntry.key.description,
          style: const TextStyle(
            fontSize: fontSize - 2,
          ),
        ),
        onChanged: (bool? value) {
          widgetStateEntry.key.showMode =
              (value ?? false) ? ShowMode.dev : ShowMode.production;
          widgetStateEntry.key.setState(() {});
          setState(() {});
        },
      ),
    );
  }
}

Future<void> _showBlockUIComponentsDialog({
  required BuildContext context,
  required Block block,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return UiComponentsDialog.block(
        block: block,
      );
    },
  );
}
