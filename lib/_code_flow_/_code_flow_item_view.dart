part of '../flutter_artist.dart';

class _CodeFlowItemView extends StatelessWidget {
  final _CodeFlowItem codeFlowItem;

  const _CodeFlowItemView({
    required this.codeFlowItem,
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    Shelf? shelf = codeFlowItem._getShelf();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LabeledRadio<bool>(
              label: "Dev Code",
              value: true,
              groupValue: codeFlowItem.isDevCode,
              onChanged: null,
            ),
            _LabeledRadio<bool>(
              label: "Lib Code",
              value: true,
              groupValue: codeFlowItem.isLibCode,
              onChanged: null,
            ),
          ],
        ),
        const Divider(),
        if (codeFlowItem.isMethodCall() && shelf != null)
          _ShelfInfoView(shelf: shelf),
        if (codeFlowItem.isMethodCall() && shelf != null) const Divider(),
        if (codeFlowItem.isMethodCall())
          Card(
            child: _CodeFlowMethodView(
              codeFlowItem: codeFlowItem,
              textSelectable: true,
              selected: false,
              onTap: null,
            ),
          ),
        if (codeFlowItem.isMethodCallWithTrace()) const SizedBox(height: 5),
        if (codeFlowItem.isMethodCallWithTrace())
          _CodeFlowFuncTraceInfoView(
            funcCallInfo: codeFlowItem.funcCallInfo!,
          ),
        if (codeFlowItem.isMethodCall()) const SizedBox(height: 10),
        if (codeFlowItem.isMethodCall())
          _CodeFlowMethodArgsView(
            arguments: codeFlowItem.funcCallInfo?.arguments,
          ),
        if (codeFlowItem.isInfo() || codeFlowItem.isError())
          _CodeFlowInfoErrorView(
            codeFlowItem: codeFlowItem,
            textOverflow: TextOverflow.visible,
            selected: false,
            onTap: null,
          )
      ],
    );
  }
}
