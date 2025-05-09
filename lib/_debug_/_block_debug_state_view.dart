part of '../flutter_artist.dart';

class _DebugBox extends StatelessWidget {
  final Widget child;

  const _DebugBox({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
      ),
      child: child,
    );
  }
}

class BlockDebugStateView extends StatelessWidget {
  final String blockName;
  final Shelf shelf;
  final bool showLastQueryType;
  final bool showForDirty;
  final bool showPaginationInfo;
  final bool showBlockInfo;
  final bool showFormInfo;
  final bool vertical;

  const BlockDebugStateView({
    super.key,
    required this.shelf,
    required this.blockName,
    required this.vertical,
    this.showLastQueryType = false,
    this.showForDirty = false,
    this.showPaginationInfo = false,
    this.showBlockInfo = true,
    this.showFormInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    const double fontSize = 11.5;
    Block block = shelf.findBlock(blockName)!;

    var labelStyle0 = const TextStyle(
      color: Colors.indigo,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );

    var textStyle0 = const TextStyle(
      color: Colors.deepOrange,
      fontSize: fontSize,
    );

    var labelStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    var textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    const double minBoxWidth = 200;

    return ShelvesSafeLayoutArea(
      ownerClassInstance: this,
      description: null,
      shelves: [shelf],
      build: () {
        List<Widget> children = [];
        if (showBlockInfo) {
          children.add(_buildBlockInfo(
              block: block,
              labelStyle0: labelStyle0,
              textStyle0: textStyle0,
              labelStyle: labelStyle,
              textStyle: textStyle));
        }
        if (showFormInfo && block.formModel != null) {
          children.add(_buildFormInfo(
              formModel: block.formModel!,
              labelStyle0: labelStyle0,
              textStyle0: textStyle0,
              labelStyle: labelStyle,
              textStyle: textStyle));
        }
        if (showPaginationInfo) {
          children.add(_buildPaginationInfo(
              block: block,
              labelStyle0: labelStyle0,
              textStyle0: textStyle0,
              labelStyle: labelStyle,
              textStyle: textStyle));
        }
        //
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.greenAccent.withAlpha(20),
              border: Border.all(width: 0.5)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int boxCount = children.length;
              //
              Widget mainWidget;
              if (vertical || boxCount <= 1) {
                mainWidget = _buildWithColumn(children);
              } else {
                if (boxCount == 3) {
                  if (constraints.constrainWidth() > 3 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithColumnAndTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
                  }
                } else if (boxCount == 2) {
                  if (constraints.constrainWidth() > 2 * minBoxWidth) {
                    mainWidget = _buildWithTableContainer(children);
                  } else {
                    mainWidget = _buildWithColumn(children);
                  }
                } else {
                  // Never run:
                  mainWidget = SizedBox();
                }
              }
              //
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(block.name),
                  const Divider(height: 10),
                  mainWidget,
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWithColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.length <= 1
          ? children
          : children
              .expand(
                (w) => [w, SizedBox(height: 5)],
              )
              .toList()
        ..removeLast(),
    );
  }

  Widget _buildWithTableContainer(List<Widget> children) {
    return _TableContainer(
      flexes: children.map((child) => 1.0).toList(),
      padding: EdgeInsets.zero,
      widgets: children,
    );
  }

  Widget _buildWithColumnAndTableContainer(List<Widget> children) {
    assert(children.length == 3);
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableContainer(
          flexes: [1, 1],
          padding: EdgeInsets.zero,
          widgets: [children[0], children[1]],
        ),
        SizedBox(height: 5),
        children[2],
      ],
    );
  }

  Widget _buildPaginationInfo({
    required Block block,
    required TextStyle labelStyle0,
    required TextStyle textStyle0,
    required TextStyle labelStyle,
    required TextStyle textStyle,
  }) {
    return _DebugBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            label: "Current Page: ",
            text: "${block.pagination?.currentPage}",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Page Size: ",
            text: "${block.pagination?.pageSize}",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Total Items: ",
            text: "${block.pagination?.totalItems}",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Total Page: ",
            text: "${block.pagination?.totalPages}",
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildBlockInfo({
    required Block block,
    required TextStyle labelStyle0,
    required TextStyle textStyle0,
    required TextStyle labelStyle,
    required TextStyle textStyle,
  }) {
    return _DebugBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            label: "UI Active?: ",
            text: "${block.hasActiveUIComponent()}",
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
          if (showLastQueryType) const SizedBox(height: 5),
          if (showLastQueryType)
            _IconLabelText(
              label: "Last Query Type: ",
              text: block.lastQueryType.name.toString(),
              labelStyle: labelStyle,
              textStyle: textStyle,
            ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Query State: ",
            text: block.queryDataState.name.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Query Count: ",
            text: block.callApiQueryCount.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Item Refresh Count: ",
            text: block.callApiRefreshItemCount.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Item Count: ",
            text: block.itemCount.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle0,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Has Current Item?: ",
            text: (block.currentItem != null).toString(),
            labelStyle: labelStyle,
            textStyle: textStyle0,
          ),
        ],
      ),
    );
  }

  Widget _buildFormInfo({
    required FormModel formModel,
    required TextStyle labelStyle0,
    required TextStyle textStyle0,
    required TextStyle labelStyle,
    required TextStyle textStyle,
  }) {
    return _DebugBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            label: "Form UI Active?: ",
            text:
                "${formModel.hasActiveUIComponent()}/${formModel.loadTimeUIActive}*",
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form Enable?: ",
            text: "${formModel.isEnabled()}",
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form State: ",
            text: formModel.formDataState.name.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form Mode: ",
            text: formModel.formMode.name.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form Load Count: ",
            text: formModel.loadCount.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form Activity Count: ",
            text: formModel.formActivityCount.toString(),
            labelStyle: labelStyle,
            textStyle: textStyle,
          ),
          if (showForDirty) const SizedBox(height: 5),
          if (showForDirty)
            _IconLabelText(
              label: "Form Dirty: ",
              text: formModel.isDirty().toString(),
              labelStyle: labelStyle0,
              textStyle: textStyle0,
            ),
        ],
      ),
    );
  }
}
