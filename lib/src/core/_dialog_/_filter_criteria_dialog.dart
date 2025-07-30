part of '../_fa_core.dart';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

class _FilterCriteriaDialog extends StatefulWidget {
  final FilterModel? filterModel;
  final Scalar? scalar;
  final Block? block;

  const _FilterCriteriaDialog.block({
    required Block this.block,
    super.key,
  })  : scalar = null,
        filterModel = null;

  const _FilterCriteriaDialog.scalar({
    required Scalar this.scalar,
    super.key,
  })  : block = null,
        filterModel = null;

  const _FilterCriteriaDialog.filterModel({
    required FilterModel this.filterModel,
    super.key,
  })  : block = null,
        scalar = null;

  @override
  State<StatefulWidget> createState() {
    return _FilterCriteriaDialogState();
  }
}

class _FilterCriteriaDialogState extends State<_FilterCriteriaDialog> {
  static const double fontSize = 13;

  String _title() {
    if (widget.scalar != null) {
      return "Current FilterCriteria of ${getClassName(widget.scalar!)}";
    } else if (widget.block != null) {
      return "Current FilterCriteria of ${getClassName(widget.block!)}";
    } else if (widget.filterModel != null) {
      return "Current FilterCriteria of ${getClassName(widget.filterModel!)}";
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    dialogs.FaAlertDialog alert = dialogs.FaAlertDialog(
      icon: Icon(
        FaIconConstants.filterCriteriaDebugIconData,
        size: 16,
      ),
      titleText: _title(),
      contentPadding: const EdgeInsets.all(5),
      content: _buildMainContent(context),
    );
    return alert;
  }

  Widget _buildMainContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (width > 620) {
      width = 600;
    } else {
      width = 0.9 * width;
    }
    if (height > 420) {
      height = 320;
    } else {
      height = height - 60;
    }
    //
    Widget child;
    if (widget.block != null) {
      child = FilterCriteriaDebugView.block(block: widget.block!);
    } else if (widget.scalar != null) {
      child = FilterCriteriaDebugView.scalar(scalar: widget.scalar!);
    } else if (widget.filterModel != null) {
      child = FilterCriteriaDebugView.filterModel(
        filterModel: widget.filterModel!,
      );
    } else {
      child = Center(
        child: Text("TODO"),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

Future<void> showFilterCriteriaDialog({
  required BuildContext context,
  required FilterModel filterModel,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return _FilterCriteriaDialog.filterModel(
        filterModel: filterModel,
      );
    },
  );
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
