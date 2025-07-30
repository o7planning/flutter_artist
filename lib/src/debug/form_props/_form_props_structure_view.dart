import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

import '../../core/_core/core.dart';
import '../../core/enums/_data_state.dart';
import '../../core/icon/icon_constants.dart';
import '../../core/utils/_class_utils.dart';
import '../../core/widgets/_custom_app_container.dart';
import '_form_model_debug_view.dart';
import 'widgets/_prop_view.dart';

class FormPropsStructureView extends StatefulWidget {
  final FormModel formModel;

  const FormPropsStructureView({
    required super.key,
    required this.formModel,
  });

  @override
  State<StatefulWidget> createState() {
    return _FormPropsStructureViewState();
  }
}

class _FormPropsStructureViewState extends State<FormPropsStructureView> {
  final MultiSplitViewController _splitViewController =
      MultiSplitViewController();
  TreeViewController<dynamic, TreeNode<dynamic>>? _treeViewController;
  late TreeNode<dynamic> rootTreeNode;
  late TreeNode<dynamic> _currentNode;

  @override
  void initState() {
    super.initState();
    //
    TreeNode formModelNode = TreeNode(
      key: "FormModel-${getClassName(widget.formModel)}",
      data: widget.formModel,
      parent: null,
    );
    _currentNode = formModelNode;
    rootTreeNode = TreeNode.root()..add(formModelNode);
    //
    FormPropsStructure structure = widget.formModel.formPropsStructure;

    List<MultiOptProp> rootMultiOptProp = structure.debugRootOptProps;
    for (MultiOptProp multiOptProp in rootMultiOptProp) {
      _addMultiOptPropCascade(formModelNode, multiOptProp);
    }
    List<SimpleProp> simpleProps = structure.simpleProps;
    for (SimpleProp simpleProp in simpleProps) {
      _addSimpleProp(formModelNode, simpleProp);
    }
    //
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

  Widget _buildRight() {
    if (_currentNode!.data is FormModel) {
      return FormModelDebugView(
        formModel: _currentNode!.data,
      );
    } else if (_currentNode!.data is Prop) {
      return FormPropView(
        formInitialDataReady: widget.formModel.formInitialDataReady,
        prop: _currentNode!.data,
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
    return CustomAppContainer(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      child: TreeView.simple(
        tree: rootTreeNode,
        showRootNode: false,
        expansionBehavior: ExpansionBehavior.none,
        expansionIndicatorBuilder: (context, node) {
          return ChevronIndicator.upDown(
            tree: node,
            color: Colors.grey[700],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
            icon: Icons.keyboard_arrow_down_outlined,
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
          bool isMultiOpt = false;
          bool isMultiSelection = false;
          IconData prefixIconData;
          bool isDirty = false;
          bool isError = false;

          if (data is FormModel) {
            title = getClassName(data);
            prefixIconData = FaIconConstants.formModelIconData;
            isError = (data as FormModel).formDataState == DataState.error;
          } else if (data is SimpleProp) {
            title = data.propName;
            prefixIconData = FaIconConstants.simplePropOrCriterionIconData;
            //
            isMultiOpt = false;
            isMultiSelection = false;
            isDirty = data.isDirty();
            isError = data.formErrorInfo != null;
          } else if (data is MultiOptProp) {
            title = data.propName;
            prefixIconData = FaIconConstants.optPropOrCriterionIconData;
            //
            isMultiOpt = true;
            isMultiSelection = !data.singleSelection;
            isDirty = data.isDirty();
            isError = data.formErrorInfo != null;
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
                  Tooltip(
                    message: isError ? 'Error' : '',
                    child: Icon(
                      prefixIconData,
                      size: 16,
                      color: isError ? Colors.red : Colors.black,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
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
                  if (isMultiOpt && isMultiSelection) const SizedBox(width: 5),
                  if (isMultiOpt && isMultiSelection)
                    const Icon(
                      FaIconConstants.multiSelectionIconData,
                      size: 16,
                      color: Colors.red,
                    ),
                  if (isDirty) const SizedBox(width: 5),
                  if (isDirty)
                    Tooltip(
                      message: "Dirty",
                      child: const Icon(
                        FaIconConstants.formPropDirtyIconData,
                        size: 16,
                        color: Colors.indigo,
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is Prop) {
                    _onPressProp(node.data);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _addMultiOptPropCascade(
      TreeNode currentNode, MultiOptProp multiOptProp) {
    TreeNode childNode = TreeNode(
      key: "MultiOptProp-${multiOptProp.propName}",
      data: multiOptProp,
    );
    // if (multiOptProp == widget.selectedProp) {
    //   _currentNode = childNode;
    // }
    currentNode.add(childNode);
    for (MultiOptProp childMultiOptProp in multiOptProp.children) {
      _addMultiOptPropCascade(childNode, childMultiOptProp);
    }
  }

  void _addSimpleProp(TreeNode currentNode, SimpleProp simpleProp) {
    TreeNode childNode = TreeNode(
      key: "SimpleProp-${simpleProp.propName}",
      data: simpleProp,
    );
    // if (simpleProp == widget.selectedProp) {
    //   _currentNode = childNode;
    // }
    currentNode.add(childNode);
  }

  void _onPressProp(Prop prop) {
    print("Prop: $prop");
  }
}
