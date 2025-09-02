import 'package:flutter/material.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../../core/enums/_data_state.dart';
import '../../core/error/_scalar_error_info.dart';
import '../../core/icon/icon_constants.dart';

class ScalarErrorViewerDialog extends StatelessWidget {
  final ScalarErrorInfo scalarErrorInfo;

  const ScalarErrorViewerDialog({
    required this.scalarErrorInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FaAlertDialog alert = FaAlertDialog(
      titleText: "Error",
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppError apiError = ErrorUtils.toAppError(scalarErrorInfo.error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight:
          apiError.errorDetails == null || apiError.errorDetails!.isEmpty
              ? 200
              : 280,
    );
    //
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${scalarErrorInfo.scalarDataState}"),
          if (scalarErrorInfo.scalarDataState == DataState.error)
            IconLabelText(
              icon: Icon(
                FaIconConstants.formErrorDisabledIconData2,
                color: Colors.red,
                size: 20,
              ),
              text: "Scalar query data error.",
            ),
          Divider(),
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(
              vertical: -3,
              horizontal: -3,
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 5,
            minVerticalPadding: 5,
            minLeadingWidth: 24,
            minTileHeight: 0,
            titleAlignment: ListTileTitleAlignment.top,
            leading: Icon(
              FaIconConstants.dataStateErrorIconData,
              size: 18,
              color: Colors.red,
            ),
            title: Text(
              apiError.errorMessage,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (apiError.errorDetails != null &&
              apiError.errorDetails!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: apiError.errorDetails != null &&
                      apiError.errorDetails!.isNotEmpty
                  ? apiError.errorDetails!
                      .map((errorDetail) => _buildErrorDetail(errorDetail))
                      .toList()
                  : [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDetail(String errorDetail) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        vertical: -3,
        horizontal: -3,
      ),
      contentPadding: const EdgeInsets.all(0),
      leading: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(
          FaIconConstants.listItemBulletIconData,
          color: Colors.black,
          size: 16,
        ),
      ),
      title: Text(
        errorDetail,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  static Future<void> showScalarErrorViewerDialog({
    required BuildContext context,
    required ScalarErrorInfo scalarErrorInfo,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScalarErrorViewerDialog(
          scalarErrorInfo: scalarErrorInfo,
        );
      },
    );
  }
}
