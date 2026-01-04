import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_artist/flutter_artist.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../core/icon/icon_constants.dart';
import '../../core/widgets/_custom_app_container.dart';
import '_filter_model_debug_view.dart';
import 'widgets/_criterion_condition_model_view.dart';

class FilterModelStructureGroupsView extends StatefulWidget {
  final FilterModel filterModel;

  const FilterModelStructureGroupsView({
    required super.key,
    required this.filterModel,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterModelStructureGroupsViewState();
  }
}

class FilterModelStructureGroupsViewState
    extends State<FilterModelStructureGroupsView> {
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
    FilterCriteriaGroupModel rootCriteriaGroupModel =
        structure.rootFilterCriteriaGroupModel;

    _addCriteriaGroupCascade(
      currentNode: filterModelNode,
      criteriaGroupModel: rootCriteriaGroupModel,
    );
    return rootTreeNode;
  }

  Widget _buildRight() {
    if (_currentNode == null) {
      return Text("Null");
    } else if (_currentNode!.data is FilterModel) {
      return FilterModelDebugView(
        filterModel: _currentNode!.data,
      );
    } else if (_currentNode!.data is FilterCriteriaGroupModel) {
      return Text("TODO-3");
    } else if (_currentNode!.data is FilterCriterionConditionModel) {
      return FilterCriterionConditionModelView(
        criterionConditionModel: _currentNode!.data,
      );
    } else {
      return Text("TODO-4");
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
            // icon: Icons.keyboard_arrow_down_outlined,
            curve: Curves.linear,
          );
        },
        indentation: const Indentation(
          style: IndentStyle.squareJoint,
          thickness: 1,
          width: 15,
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
          } else if (data is FilterCriteriaGroupModel) {
            title = data.conjunction == Conjunction.and
                ? "AND - ${data.groupName}"
                : "OR - ${data.groupName}";
            tooltip =
                "${getClassNameWithoutGenerics(data)} > ${data.groupName}";
            prefixIconData = FaIconConstants.filterCriteriaGroupIconData;
            //
            isMultiOpt = false;
            isMultiSelection = false;
          } else if (data is FilterCriterionConditionModel) {
            FilterCriterionModel criterionModel = data.criterionModel;

            if (criterionModel is SimpleFilterCriterionModel) {
              title = data.criterionNamePlus;
              tooltip =
                  "${getClassNameWithoutGenerics(data)}<${criterionModel.dataType.toString()}> ${data.criterionNamePlus}";
              prefixIconData = FaIconConstants.simplePropOrCriterionIconData;
              //
              isMultiOpt = false;
              isMultiSelection = false;
            } else if (criterionModel is MultiOptFilterCriterionModel) {
              title = data.criterionNamePlus;
              tooltip =
                  "${getClassNameWithoutGenerics(data)}<${criterionModel.dataType.toString()}> ${data.criterionNamePlus}";
              prefixIconData = FaIconConstants.optPropOrCriterionIconData;
              //
              isMultiOpt = true;
              isMultiSelection =
                  criterionModel.selectionType == SelectionType.multi;
            } else {
              throw "Never Run";
            }
          } else {
            prefixIconData = FaIconConstants.uknownIconData;
            title = "UNKNOWN";
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
                  if (node.data is FilterCriterionModel) {
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

  void _addCriteriaGroupCascade({
    required TreeNode currentNode,
    required FilterCriteriaGroupModel criteriaGroupModel,
  }) {
    TreeNode childNode = TreeNode(
      key: "FilterCriteriaGroupModel-${criteriaGroupModel.groupName}",
      data: criteriaGroupModel,
    );
    currentNode.add(childNode);
    //

    for (FilterConditionModel conditionModel
        in criteriaGroupModel.childConditionModels) {
      if (conditionModel is FilterCriteriaGroupModel) {
        _addCriteriaGroupCascade(
          currentNode: childNode,
          criteriaGroupModel: conditionModel,
        );
      } else if (conditionModel is FilterCriterionConditionModel) {
        _addCriterionConditionModelNode(
          currentNode: childNode,
          criterionConditionModel: conditionModel,
        );
      }
    }
  }

  void _addCriterionConditionModelNode({
    required TreeNode currentNode,
    required FilterCriterionConditionModel criterionConditionModel,
  }) {
    TreeNode childNode = TreeNode(
      // key: "FilterCriterionConditionModel-${multiOptCriterionModel.criterionNamePlus}",
      data: criterionConditionModel,
    );
    //
    currentNode.add(childNode);
  }

  void _onPressCriterion(FilterCriterionModel criterion) {
    print("Criterion: $criterion");
  }
}
