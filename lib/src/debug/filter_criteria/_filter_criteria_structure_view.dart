import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../core/_core_/core.dart';
import '../../core/enums/_selection_type.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '_filter_model_debug_view.dart';
import 'widgets/_tilde_filter_criteria_view.dart';

class FilterCriteriaStructureView extends StatefulWidget {
  final FilterModel filterModel;

  const FilterCriteriaStructureView({
    required super.key,
    required this.filterModel,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterCriteriaStructureViewState();
  }
}

class FilterCriteriaStructureViewState
    extends State<FilterCriteriaStructureView> {
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
          return buildTreeView(context);
        },
      ),
      Area(
        size: 320,
        // flex: 1,
        min: 240,
        builder: (context, area) {
          return _buildRight();
        },
      ),
    ];
    _splitViewController.addListener(_refresh);
  }

  TreeNode _getRootWithChildren() {
    TreeNode filterModelNode = TreeNode(
      key: "FilterModel-${getClassName(widget.filterModel)}",
      data: widget.filterModel,
      parent: null,
    );
    _currentNode = filterModelNode;
    rootTreeNode = TreeNode.root()..add(filterModelNode);
    //
    FilterModelStructure structure = widget.filterModel.filterModelStructure;

    List<MultiOptTildeFilterCriterionModel> rootMultiOptCriterion =
        structure.debugRootOptCriteria;
    for (MultiOptTildeFilterCriterionModel multiOptCriterion
        in rootMultiOptCriterion) {
      _addMultiOptCriterionCascade(filterModelNode, multiOptCriterion);
    }
    List<SimpleTildeFilterCriterionModel> simpleCriteria =
        structure.debugSimpleCriteria;
    for (SimpleTildeFilterCriterionModel simpleCriterion in simpleCriteria) {
      _addSimpleCriterion(filterModelNode, simpleCriterion);
    }

    return rootTreeNode;
  }

  Widget _buildRight() {
    if (_currentNode == null) {
      return Text("Null");
    } else if (_currentNode!.data is FilterModel) {
      return FilterModelDebugView(
        filterModel: _currentNode!.data,
      );
    } else if (_currentNode!.data is TildeFilterCriterionModel) {
      return TildeFilterCriterionView(
        criterion: _currentNode!.data,
      );
    } else {
      return Text("TODO");
    }
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _splitViewController.removeListener(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    MultiSplitView multiSplitView = MultiSplitView(
      controller: _splitViewController,
    );
    return multiSplitView;
  }

  // ***************************************************************************
  // ***************************************************************************

  Widget buildTreeView(BuildContext context) {
    FilterModelStructure filterModelStructure =
        widget.filterModel.filterModelStructure;
    //
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: TreeView.simple(
        tree: rootTreeNode,
        showRootNode: false,
        expansionBehavior: ExpansionBehavior.none,
        expansionIndicatorBuilder: (context, node) {
          return PlusMinusIndicator(
            tree: node,
            color: Colors.grey[600],
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            curve: Curves.linear,
          );
        },
        indentation: const Indentation(
          style: IndentStyle.squareJoint,
          thickness: 1,
          width: 10,
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
          bool isMultiOpt = false;
          bool isMultiSelection = false;
          IconData prefixIconData;

          if (data is FilterModel) {
            title = getClassName(data);
            prefixIconData = FaIconConstants.filterModelIconData;
          } else if (data is SimpleTildeFilterCriterionModel) {
            title = data.tildeCriterionName;
            tooltip =
                "${getClassNameWithoutGenerics(data)}<${data.dataType.toString()}> ${data.tildeCriterionName}";
            prefixIconData = FaIconConstants.simplePropOrCriterionIconData;
            //
            isMultiOpt = false;
            isMultiSelection = false;
          } else if (data is MultiOptTildeFilterCriterionModel) {
            title = data.tildeCriterionName;
            tooltip =
                "${getClassNameWithoutGenerics(data)}<${data.dataType.toString()}> ${data.tildeCriterionName}";
            prefixIconData = FaIconConstants.optPropOrCriterionIconData;
            //
            isMultiOpt = true;
            isMultiSelection = data.selectionType == SelectionType.multi;
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
                          fontWeight: _currentNode == node
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  if (isMultiOpt && isMultiSelection) const SizedBox(width: 5),
                  if (isMultiOpt && isMultiSelection)
                    Tooltip(
                      message: "Multi Selection",
                      child: const Icon(
                        FaIconConstants.multiSelectionIconData,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is TildeFilterCriterionModel) {
                    _onPressCriterion(node.data);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _addMultiOptCriterionCascade(TreeNode currentNode,
      MultiOptTildeFilterCriterionModel multiOptCriterion) {
    TreeNode childNode = TreeNode(
      key: "MultiOptCriterion-${multiOptCriterion.tildeCriterionName}",
      data: multiOptCriterion,
    );
    //
    currentNode.add(childNode);
    for (MultiOptTildeFilterCriterionModel childMultiOptCriterion
        in multiOptCriterion.children) {
      _addMultiOptCriterionCascade(childNode, childMultiOptCriterion);
    }
  }

  void _addSimpleCriterion(
      TreeNode currentNode, SimpleTildeFilterCriterionModel simpleCriterion) {
    TreeNode childNode = TreeNode(
      key: "SimpleCriterion-${simpleCriterion.tildeCriterionName}",
      data: simpleCriterion,
    );
    // if (simpleCriterion == widget.selectedCriterion) {
    //   _currentNode = childNode;
    // }
    currentNode.add(childNode);
  }

  void _onPressCriterion(TildeFilterCriterionModel criterion) {
    print("Criterion: $criterion");
  }
}
