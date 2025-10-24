import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../../core/_core_/core.dart';
import '../../../core/icon/icon_constants.dart';
import '../../../core/utils/_class_utils.dart';
import '../../../core/widgets/_custom_app_container.dart';
import '_x_block_view.dart';
import '_x_scalar_view.dart';
import '_x_shelf_view.dart';

class XShelfTreeView extends StatefulWidget {
  final XShelf xShelf;

  const XShelfTreeView({
    super.key,
    required this.xShelf,
  });

  @override
  State<StatefulWidget> createState() {
    return _XShelfTreeViewState();
  }
}

class _XShelfTreeViewState extends State<XShelfTreeView> {
  final MultiSplitViewController _splitViewController =
      MultiSplitViewController();

  TreeViewController<dynamic, TreeNode<dynamic>>? _treeViewController;
  late TreeNode<dynamic> rootTreeNode;
  TreeNode<dynamic>? _currentNode;

  @override
  void initState() {
    super.initState();
    rootTreeNode = _getRootWithChildren();
    _splitViewController.areas = [
      Area(
        size: 320,
        min: 120,
        builder: (context, area) {
          return _buildTreeView(context);
        },
      ),
      Area(
        size: 320,
        // flex: 1,
        min: 240,
        builder: (context, area) {
          return _buildRight(context);
        },
      ),
    ];
    _splitViewController.addListener(_refresh);
  }

  void _refresh() {
    setState(() {});
  }

  TreeNode _getRootWithChildren() {
    TreeNode xShelfNode = TreeNode(
      key: "Debug-XShelf-${getClassName(widget.xShelf)}",
      data: widget.xShelf,
      parent: null,
    );
    _currentNode = xShelfNode;
    rootTreeNode = TreeNode.root()..add(xShelfNode);
    //
    List<XBlock> allRootXBlocks = widget.xShelf.allRootXBlocks;
    for (XBlock multiOptCriterion in allRootXBlocks) {
      _addXBlockCascade(xShelfNode, multiOptCriterion);
    }
    List<XScalar> xScalars = widget.xShelf.allXScalars;
    for (XScalar xScalar in xScalars) {
      _addXScalar(xShelfNode, xScalar);
    }
    return rootTreeNode;
  }

  void _addXBlockCascade(TreeNode currentNode, XBlock xBlock) {
    TreeNode childNode = TreeNode(
      key: "XBlock-${xBlock.name}",
      data: xBlock,
    );
    //
    currentNode.add(childNode);
    for (XBlock childXBlock in xBlock.childXBlocks) {
      _addXBlockCascade(childNode, childXBlock);
    }
  }

  void _addXScalar(TreeNode currentNode, XScalar xScalar) {
    TreeNode childNode = TreeNode(
      key: "XScalar-${xScalar.name}",
      data: xScalar,
    );
    //
    currentNode.add(childNode);
  }

  Widget _buildRight(BuildContext context) {
    dynamic data = _currentNode?.data;
    if (data is XShelf) {
      return XShelfView(xShelf: data);
    } else if (data is XBlock) {
      return XBlockView(xBlock: data);
    } else if (data is XScalar) {
      return XScalarView(xScalar: data);
    }
    return Text("");
  }

  Widget _buildTreeView(BuildContext context) {
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: TreeView.simple(
        tree: rootTreeNode,
        showRootNode: false,
        expansionBehavior: ExpansionBehavior.snapToTop,
        expansionIndicatorBuilder: (context, node) {
          // PlusMinusIndicator
          // ChevronIndicator.upDown
          return PlusMinusIndicator(
            tree: node,
            color: Colors.grey[600],
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            curve: Curves.linear,
          );
        },
        indentation: const Indentation(
          style: IndentStyle.roundJoint,
          thickness: 1,
        ),
        onTreeReady: (
          TreeViewController<dynamic, TreeNode<dynamic>> controller,
        ) {
          _treeViewController = controller;
          controller.expandAllChildren(rootTreeNode);
        },
        builder: (context, node) {
          dynamic data = node.data;
          String title;
          String? tooltip;
          IconData prefixIconData;
          bool rootVip = false;
          bool showReQueryIcon = false;
          bool showRefreshCurrItemIcon = false;
          Color textColor = Colors.black;

          if (data is XShelf) {
            title = "${data.shelf.name} (ID: ${data.xShelfId})";
            tooltip = "XShelf: $title";
            prefixIconData = FaIconConstants.shelfStructureIconData;
            rootVip = false;
          } else if (data is XScalar) {
            title = data.name;
            tooltip = "Scalar: $title";
            prefixIconData = FaIconConstants.scalarIconData;
            if (!data.isReQueryDone()) {
              textColor = Colors.red;
              showReQueryIcon = true;
            }
            rootVip = data.isVipBranch();
          } else if (data is XBlock) {
            title = data.name;
            tooltip = "Block: $title";
            prefixIconData = FaIconConstants.blockIconData;
            if (!data.isReQueryDone()) {
              textColor = Colors.red;
              showReQueryIcon = true;
            }
            if (!data.isReloadCurrItemDone()) {
              textColor = Colors.red;
              showRefreshCurrItemIcon = true;
            }
            rootVip = data.isRoot() && data.isVipBranch();
          } else if (data is XFormModel) {
            title = data.name;
            tooltip = "FormModel: $title";
            prefixIconData = FaIconConstants.optPropOrCriterionIconData;
            rootVip = false;
          } else {
            prefixIconData = FaIconConstants.uknownIconData;
            title = "UKNOWN";
          }
          return Material(
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(
                horizontal: -3,
                vertical: -3,
              ),
              contentPadding: const EdgeInsets.only(left: 25),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    prefixIconData,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Tooltip(
                      message: tooltip ?? "",
                      child: Text(
                        title,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 13,
                          color: textColor,
                          fontWeight: _currentNode == node
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  if (showReQueryIcon)
                    Tooltip(
                      message: "Need to Re-Query",
                      child: Icon(
                        FaIconConstants.formQueryIconData,
                        size: 16,
                      ),
                    ),
                  if (showRefreshCurrItemIcon)
                    Tooltip(
                      message: "Need to Refresh Current Item",
                      child: Icon(
                        FaIconConstants.formRefreshIconData,
                        size: 16,
                      ),
                    ),
                  if (rootVip)
                    Tooltip(
                      message: "VIP Branch",
                      child: Icon(
                        FaIconConstants.vipBranchIconData,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is FilterCriterion) {
                    // _onPressCriterion(node.data);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MultiSplitView multiSplitView = MultiSplitView(
      controller: _splitViewController,
    );
    return multiSplitView;
  }

  @override
  void dispose() {
    super.dispose();
    _splitViewController.removeListener(_refresh);
  }
}
