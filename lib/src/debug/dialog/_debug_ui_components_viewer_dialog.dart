import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_show_mode.dart';
import '../../core/enums/_tip_document.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '_tip_document_viewer_dialog.dart';

class DebugUiComponentsViewerDialog extends StatefulWidget {
  final Shelf? shelf;
  final Block? block;
  final Scalar? scalar;
  final bool showActiveOnly;

  const DebugUiComponentsViewerDialog.block({
    required Block this.block,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        scalar = null;

  const DebugUiComponentsViewerDialog.scalar({
    required Scalar this.scalar,
    this.showActiveOnly = true,
    super.key,
  })  : shelf = null,
        block = null;

  const DebugUiComponentsViewerDialog.shelf({
    required Shelf this.shelf,
    this.showActiveOnly = true,
    super.key,
  })  : block = null,
        scalar = null;

  @override
  State<StatefulWidget> createState() {
    return _DebugUiComponentsViewerDialogState();
  }

  static Future<void> open({
    required BuildContext context,
    required Shelf shelf,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DebugUiComponentsViewerDialog.shelf(
          shelf: shelf,
        );
      },
    );
  }
}

class _DebugUiComponentsViewerDialogState
    extends State<DebugUiComponentsViewerDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.shelf != null) {
      return "Active UI Components in current screen";
    } else if (widget.block != null) {
      return "Mounted UI Components of the Block";
    } else if (widget.scalar != null) {
      return "Mounted UI Components of the Scalar";
    } else {
      throw UnimplementedError();
    }
  }

  Map<IContextProviderViewState, XState> _findWidgetStates() {
    if (widget.shelf != null) {
      return widget.shelf!.ui.debugFindMountedWidgetStates(
        activeOnly: true,
        withPagination: true,
        withBlockFragment: true,
        withScalarFragment: true,
        withFilter: true,
        withSort: true,
        withForm: true,
        withBlockControlBar: true,
        withScalarControlBar: true,
        withControl: true,
      );
    } else if (widget.block != null) {
      return widget.block!.ui.debugFindMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withBlockBaseView: true,
        withFilter: true,
        withSort: true,
        withForm: true,
        withBlockControlBar: true,
        withControl: true,
      );
    } else if (widget.scalar != null) {
      return widget.scalar!.ui.debugFindMountedWidgetStates(
        activeOnly: false,
        withPagination: true,
        withScalarBaseView: true,
        withFilter: true,
        withScalarControlBar: true,
      );
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      icon: Icon(
        FaIconConstants.uiComponentsIconData,
        size: 18,
      ),
      titleText: "Debug UI Components Viewer",
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
      onHelpPressed: () {
        TipDocumentViewerDialog.open(
          context: context,
          tipDocument: TipDocument.debugUiComponentsViewer,
        );
      },
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    final size = calculatePreferredDialogSize(
      context,
      preferredWidth: 560,
      preferredHeight: 320,
    );
    //
    Map<IContextProviderViewState, XState> widgetStates = _findWidgetStates();
    return SizedBox(
      width: size.width,
      height: size.height,
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
          if (widget.block != null) const SizedBox(height: 10),
          Text(_title()),
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
    required MapEntry<IContextProviderViewState, XState> widgetStateEntry,
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
            color: widgetStateEntry.value.isVisible
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
