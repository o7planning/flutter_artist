part of '../../flutter_artist.dart';

class FormErrorViewerDialog extends StatelessWidget {
  final FormErrorInfo formErrorInfo;
  final bool formInitialDataReady;

  const FormErrorViewerDialog({
    required this.formErrorInfo,
    required this.formInitialDataReady,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: "Form Error",
      contentPadding: EdgeInsets.all(8),
      content: _buildContent(context),
    );
    return alert;
  }

  Widget _buildContent(BuildContext context) {
    AppError exception = ErrorUtils.toAppError(formErrorInfo.error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight:
      exception.errorDetails == null || exception.errorDetails!.isEmpty
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
          if (!formInitialDataReady)
            IconLabelText(
              icon: Icon(
                _formErrorDisabledIconData2,
                color: Colors.red,
                size: 20,
              ),
              text: "Form is disabled due to data initialization error.",
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
              _dataStateErrorIconData,
              size: 18,
              color: Colors.red,
            ),
            title: Text(
              exception.errorMessage,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (exception != null &&
              exception.errorDetails != null &&
              exception.errorDetails!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: exception != null &&
                  exception.errorDetails != null &&
                  exception.errorDetails!.isNotEmpty
                  ? exception.errorDetails!
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
          _listItemBulletIconData,
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
}

Future<void> _showFormErrorViewerDialog({
  required BuildContext context,
  required FormErrorInfo formErrorInfo,
  required bool formInitialDataReady,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return FormErrorViewerDialog(
        formErrorInfo: formErrorInfo,
        formInitialDataReady: formInitialDataReady,
      );
    },
  );
}
