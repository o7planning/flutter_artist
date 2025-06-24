part of '../../flutter_artist.dart';

class FormErrorViewerDialog extends StatelessWidget {
  final Object error;
  final bool formInitialDataReady;

  const FormErrorViewerDialog({
    required this.error,
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
    AppException exception = ErrorUtils.toAppException(error);
    //
    final Size size = calculatePreferredDialogSize(
      context,
      preferredWidth: 440,
      preferredHeight:
          exception.details == null || exception.details!.isEmpty ? 200 : 280,
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
          IconLabelText(
            label: "Initial FormData Ready? ",
            text: "",
            suffixIcon: Checkbox(
              value: formInitialDataReady,
              onChanged: null,
            ),
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
              exception?.message ?? "null",
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (exception != null &&
              exception!.details != null &&
              exception!.details!.isNotEmpty)
            Divider(height: 10),
          Expanded(
            child: ListView(
              children: exception != null &&
                      exception!.details != null &&
                      exception!.details!.isNotEmpty
                  ? exception!.details!
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
  required Object error,
  required bool formInitialDataReady,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return FormErrorViewerDialog(
        error: error,
        formInitialDataReady: formInitialDataReady,
      );
    },
  );
}
