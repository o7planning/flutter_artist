part of '../flutter_artist.dart';

class _DebugBox extends StatelessWidget {
  final Widget child;

  const _DebugBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
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

  const BlockDebugStateView({
    super.key,
    required this.shelf,
    required this.blockName,
    this.showLastQueryType = false,
    this.showForDirty = false,
    this.showPaginationInfo = false,
    this.showBlockInfo = true,
    this.showFormInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    const double fontSize = 12;
    Block block = shelf.findBlock(blockName)!;
    FormModel? formModel = block.formModel;

    var labelStyle0 = const TextStyle(
      color: Colors.indigo,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );

    var textStyle0 = const TextStyle(
      color: Colors.deepOrange,
      fontWeight: FontWeight.bold,
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
    const double minBoxWidth = 120;
    final int totalBox = formModel == null ? 2 : 3;

    //
    return ShelvesSafeLayoutArea(
      ownerClassInstance: this,
      description: null,
      shelves: [shelf],
      build: () {
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.greenAccent.withAlpha(20),
              border: Border.all(width: 0.5)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.constrainWidth() > totalBox * minBoxWidth) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildBlockInfo(
                        block: block,
                        labelStyle0: labelStyle0,
                        textStyle0: textStyle0,
                        labelStyle: labelStyle,
                        textStyle: textStyle,
                      ),
                    ),
                    if (formModel != null) const SizedBox(width: 5),
                    if (formModel != null)
                      Expanded(
                        child: _buildFormInfo(
                          formModel: formModel,
                          labelStyle0: labelStyle0,
                          textStyle0: textStyle0,
                          labelStyle: labelStyle,
                          textStyle: textStyle,
                        ),
                      ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildPaginationInfo(
                        block: block,
                        labelStyle0: labelStyle0,
                        textStyle0: textStyle0,
                        labelStyle: labelStyle,
                        textStyle: textStyle,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBlockInfo)
                      _buildBlockInfo(
                        block: block,
                        labelStyle0: labelStyle0,
                        textStyle0: textStyle0,
                        labelStyle: labelStyle,
                        textStyle: textStyle,
                      ),
                    if (showFormInfo && formModel != null)
                      const Divider(height: 5),
                    if (showFormInfo && formModel != null)
                      _buildFormInfo(
                        formModel: formModel,
                        labelStyle0: labelStyle0,
                        textStyle0: textStyle0,
                        labelStyle: labelStyle,
                        textStyle: textStyle,
                      ),
                    if (showPaginationInfo) const Divider(height: 5),
                    if (showPaginationInfo)
                      _buildPaginationInfo(
                        block: block,
                        labelStyle0: labelStyle0,
                        textStyle0: textStyle0,
                        labelStyle: labelStyle,
                        textStyle: textStyle,
                      ),
                  ],
                );
              }
            },
          ),
        );
      },
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
            label: "UI Active? *: ",
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
            label: "Form UI Active? *: ",
            text:
                "${formModel.hasActiveUIComponent()}/${formModel.loadTimeUIActive}*",
            labelStyle: labelStyle0,
            textStyle: textStyle0,
          ),
          const SizedBox(height: 5),
          _IconLabelText(
            label: "Form Enable? *: ",
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
