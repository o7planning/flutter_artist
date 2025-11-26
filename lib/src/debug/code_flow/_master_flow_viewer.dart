import 'package:flutter/material.dart';

import '../../core/_core_/core.dart';
import '../../core/widgets/_custom_app_container.dart';
import '../../core/widgets/_labeled_radio.dart';
import '_master_flow_filter.dart';
import '_master_flow_item_box.dart';
import '_master_flow_item_box_detail.dart';

class MasterFlowViewer extends StatefulWidget {
  const MasterFlowViewer({
    super.key,
  });

  @override
  State<MasterFlowViewer> createState() => _MasterFlowViewerState();
}

class _MasterFlowViewerState extends State<MasterFlowViewer> {
  MasterFlowItem? selectedFlowItem;
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

  bool _checkItem(MasterFlowItem item) {
    // bool ok1 = (showDevMethod && item.isDevCode && item.isMethodCall());
    // if (ok1) {
    //   return true;
    // }
    // bool ok2 = (showPublicMethod && item.isPublicMethodCall()) ||
    //     (showPrivateMethod && item.isPrivateMethodCall()) ||
    //     (showInfo && item.isInfo()) ||
    //     (showError && item.isError());
    // return ok2;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<MasterFlowItem> items = FlutterArtist.codeFlowLogger.masterFlowItems;
    items = items.where((item) => _checkItem(item)).toList();

    if (!items.contains(selectedFlowItem)) {
      selectedFlowItem = items.isNotEmpty ? items.first : null;
    }
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopFilter(),
        const SizedBox(height: 5),
        Expanded(
          child: selectedFlowItem == null
              ? const CustomAppContainer(
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
                      child: _buildRightView(selectedFlowItem!),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTopFilter() {
    return MasterFlowFilter(
      masterFlowItemTypes: [],
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
    );
  }

  Widget _buildLeftList(List<MasterFlowItem> items) {
    return ListView(
      padding: const EdgeInsets.only(right: 10),
      children: items
          .map(
            (masterFlowItem) => MasterFlowItemBox(
              key: Key("LogItem-${masterFlowItem.id}"),
              masterFlowItem: masterFlowItem,
              selected: masterFlowItem == selectedFlowItem,
              onTap: () {
                setState(() {
                  selectedFlowItem = masterFlowItem;
                });
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildRightFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledRadio<bool>(
          label: "Dev Code",
          value: true,
          groupValue: true, // masterFlowItem.isDevCode,
          onChanged: null,
        ),
        LabeledRadio<bool>(
          label: "Lib Code",
          value: true,
          groupValue: true, // masterFlowItem.isLibCode,
          onChanged: null,
        ),
      ],
    );
  }

  Widget _buildRightView(MasterFlowItem masterFlowItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildRightFilter(),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: MasterFlowItemDetailView(
              masterFlowItem: masterFlowItem,
            ),
          ),
        ),
      ],
    );
  }
}
