part of '../../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _CodeFlowViewerDialog extends StatefulWidget {
  const _CodeFlowViewerDialog({
    super.key,
  });

  @override
  State<_CodeFlowViewerDialog> createState() {
    return _CodeFlowViewerDialogState();
  }
}

class _CodeFlowViewerDialogState extends State<_CodeFlowViewerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = _calculateDebugDialogSize(context);

    Widget contentWidget = _CustomAppContainer(
      padding: const EdgeInsets.all(2),
      width: size.width,
      height: size.height,
      child: _buildMainWidget(),
    );

    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      titleText: "Code Flow Viewer",
      content: contentWidget,
      contentPadding: EdgeInsets.zero,
    );
    return alert;
  }

  Widget _buildMainWidget() {
    return const _CodeFlowViewer();
  }
}

Future<void> _showFlowLogViewerDialog({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return const _CodeFlowViewerDialog();
    },
  );
}
