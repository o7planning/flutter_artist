import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../core/_core_/core.dart';
import '../../core/_core_/_enums_/_enums.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/__utils.dart';

import '../../core/widgets/__widgets.dart';
import '_filter_model_debug_view.dart';
import 'widgets/_criterion_def_view.dart';

class FilterModelStructureCriteriaBaseView extends StatefulWidget {
  final FilterModel filterModel;

  const FilterModelStructureCriteriaBaseView({
    required super.key,
    required this.filterModel,
  });

  @override
  State<StatefulWidget> createState() {
    return FilterModelStructureCriteriaBaseViewState();
  }
}

class FilterModelStructureCriteriaBaseViewState
    extends State<FilterModelStructureCriteriaBaseView> {
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
    //
    List<ManagedOptFilterCriterionDef> rootManagedOptCriterion =
        structure.criteriaStructure.managedOptCriterionDefs;
    for (ManagedOptFilterCriterionDef managedOptCriterion
        in rootManagedOptCriterion) {
      _addManagedOptCriterionCascade(filterModelNode, managedOptCriterion);
    }
    List<PlainFilterCriterionDef> plainCriteria =
        structure.criteriaStructure.plainCriterionDefs;
    for (PlainFilterCriterionDef plainCriterion in plainCriteria) {
      _addPlainCriterion(filterModelNode, plainCriterion);
    }
    //
    return rootTreeNode;
  }

  Widget _buildRight() {
    final colorScheme = Theme.of(context).colorScheme;

    if (_currentNode == null) {
      return Center(
        child: Text(
          "Select a node to see definition",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return _getContentByData(_currentNode!.data);
  }

  Widget _getContentByData(dynamic data) {
    if (data is FilterModel) {
      return FilterModelDebugView(filterModel: data);
    } else if (data is FilterCriterionDef) {
      return FilterCriterionDefView(criterion: data);
    } else {
      return const Center(child: Text("Criterion detail not available"));
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            color: theme.hintColor.withValues(alpha: 0.7),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
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
          final isSelected = _currentNode == node;
          dynamic data = node.data;
          String title;
          String? tooltip;
          bool isManagedOpt = false;
          bool isMultiSelection = false;
          IconData prefixIconData;

          if (data is FilterModel) {
            title = getClassName(data);
            prefixIconData = FaIconConstants.filterModelIconData;
          } else if (data is PlainFilterCriterionDef) {
            title = data.criterionBaseName;
            tooltip =
                "${getClassNameWithoutGenerics(data)}<${data.dataType.toString()}> ${data.criterionBaseName}";
            prefixIconData = FaIconConstants.plainPropOrCriterionIconData;
            //
            isManagedOpt = false;
            isMultiSelection = false;
          } else if (data is ManagedOptFilterCriterionDef) {
            title = data.criterionBaseName;
            tooltip =
                "${getClassNameWithoutGenerics(data)}<${data.dataType.toString()}> ${data.criterionBaseName}";
            prefixIconData = FaIconConstants.managedPropOrCriterionIconData;
            //
            isManagedOpt = true;
            isMultiSelection =
                data.selectionMode == ManagedOptSelectionMode.multi;
          } else {
            prefixIconData = FaIconConstants.unknownIconData;
            title = "UNKNOWN";
          }
          return Material(
            color: Colors.transparent,
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
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
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
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontWeight: _currentNode == node
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  if (isManagedOpt && isMultiSelection)
                    const SizedBox(width: 5),
                  if (isManagedOpt && isMultiSelection)
                    Tooltip(
                      message: "Multi Selection",
                      child: Icon(
                        FaIconConstants.multiSelectionIconData,
                        size: 16,
                        color: colorScheme.error.withValues(alpha: 0.8),
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

  void _addManagedOptCriterionCascade(
      TreeNode currentNode, ManagedOptFilterCriterionDef managedOptCriterion) {
    TreeNode childNode = TreeNode(
      key: "ManagedOptCriterion-${managedOptCriterion.criterionBaseName}",
      data: managedOptCriterion,
    );
    //
    currentNode.add(childNode);
    for (ManagedOptFilterCriterionDef childManagedOptCriterion
        in managedOptCriterion.children) {
      _addManagedOptCriterionCascade(childNode, childManagedOptCriterion);
    }
  }

  void _addPlainCriterion(
      TreeNode currentNode, PlainFilterCriterionDef plainCriterion) {
    TreeNode childNode = TreeNode(
      key: "PlainCriterion-${plainCriterion.criterionBaseName}",
      data: plainCriterion,
    );
    currentNode.add(childNode);
  }

  void _onPressCriterion(TildeFilterCriterionModel criterion) {
    print("Criterion: $criterion");
  }
}
