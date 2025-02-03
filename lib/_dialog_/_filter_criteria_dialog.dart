part of '../flutter_artist.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FilterCriteriaDialog extends StatefulWidget {
  final Scalar? scalar;
  final Block? block;

  const _FilterCriteriaDialog.block({
    required Block this.block,
    super.key,
  }) : scalar = null;

  const _FilterCriteriaDialog.scalar({
    required Scalar this.scalar,
    super.key,
  }) : block = null;

  @override
  State<StatefulWidget> createState() {
    return _FilterCriteriaDialogState();
  }
}

class _FilterCriteriaDialogState extends State<_FilterCriteriaDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.scalar != null) {
      return "Current FilterCriteria of Scalar";
    } else if (widget.block != null) {
      return "Current FilterCriteria of Block";
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    dialogs.CustomAlertDialog alert = dialogs.CustomAlertDialog(
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
    if (widget.block != null) {
      return _FilterCriteriaDebugView.block(block: widget.block!);
    } else if (widget.scalar != null) {
      return _FilterCriteriaDebugView.scalar(scalar: widget.scalar!);
    } else {
      return Center(
        child: Text("TODO"),
      );
    }
  }
}

Future<void> showBlockFilterCriteriaDialog({
  required BuildContext context,
  required Block block,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FilterCriteriaDialog.block(
        block: block,
      );
    },
  );
}

Future<void> showScalarFilterCriteriaDialog({
  required BuildContext context,
  required Scalar scalar,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FilterCriteriaDialog.scalar(
        scalar: scalar,
      );
    },
  );
}
