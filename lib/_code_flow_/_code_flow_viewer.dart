part of '../flutter_artist.dart';

class _CodeFlowViewer extends StatefulWidget {
  const _CodeFlowViewer({
    super.key,
  });

  @override
  State<_CodeFlowViewer> createState() => _CodeFlowViewerState();
}

class _CodeFlowViewerState extends State<_CodeFlowViewer> {
  _CodeFlowItem? selectedFlowItem;
  bool showDevMethod = true;

  //
  bool showPublicMethod = true;
  bool showPrivateMethod = false;

  //
  bool showInfo = true;
  bool showError = true;

  @override
  void initState() {
    super.initState();
  }

  bool _checkItem(_CodeFlowItem item) {
    bool ok1 = (showDevMethod && item.isDevCode && item.isMethodCall());
    if (ok1) {
      return true;
    }
    bool ok2 = (showPublicMethod && item.isPublicMethodCall()) ||
        (showPrivateMethod && item.isPrivateMethodCall()) ||
        (showInfo && item.isInfo()) ||
        (showError && item.isError());
    return ok2;
  }

  @override
  Widget build(BuildContext context) {
    List<_CodeFlowItem> items = [...Storage.codeFlowLogger._codeFlowItems];
    items = items.where((item) => _checkItem(item)).toList();

    if (!items.contains(selectedFlowItem)) {
      selectedFlowItem = items.isNotEmpty ? items.first : null;
    }
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CodeFlowFilter(
          codeFlowItemTypes: [],
          showDevMethod: showDevMethod,
          showPublicMethod: showPublicMethod,
          showPrivateMethod: showPrivateMethod,
          showInfo: showInfo,
          showError: showError,
          onShowDevMethodChanged: (bool? value) {
            setState(() {
              showDevMethod = value ?? false;
            });
          },
          onShowPublicMethodChanged: (bool? value) {
            setState(() {
              showPublicMethod = value ?? false;
            });
          },
          onShowPrivateMethodChanged: (bool? value) {
            setState(() {
              showPrivateMethod = value ?? false;
            });
          },
          onShowInfoChanged: (bool? value) {
            setState(() {
              showInfo = value ?? false;
            });
          },
          onShowErrorChanged: (bool? value) {
            setState(() {
              showError = value ?? false;
            });
          },
        ),
        const SizedBox(height: 5),
        Expanded(
          child: selectedFlowItem == null
              ? const _CustomAppContainer(
                  child: Center(
                    child: Text("No Item", style: TextStyle(fontSize: 13)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 280,
                      child: _buildLeftList(items),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildRightView(selectedFlowItem!),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildLeftList(List<_CodeFlowItem> items) {
    return ListView(
      padding: const EdgeInsets.only(right: 10),
      children: items
          .map(
            (logItem) => _CodeFlowListItem(
              key: Key("LogItem-${logItem.id}"),
              flowLogItem: logItem,
              selected: logItem == selectedFlowItem,
              onTap: () {
                setState(() {
                  selectedFlowItem = logItem;
                });
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildRightView(_CodeFlowItem codeFlowItem) {
    return _CodeFlowItemView(
      key: Key("LogItem-${selectedFlowItem?.id}"),
      codeFlowItem: codeFlowItem,
    );
  }
}
