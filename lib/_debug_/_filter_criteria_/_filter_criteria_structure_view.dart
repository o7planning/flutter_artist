part of '../../flutter_artist.dart';

class _FilterCriteriaStructureView extends StatefulWidget {
  final FilterModel filterModel;

  const _FilterCriteriaStructureView({
    required super.key,
    required this.filterModel,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterCriteriaStructureViewState();
  }
}

class _FilterCriteriaStructureViewState
    extends State<_FilterCriteriaStructureView> {
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

  Widget _buildRight() {
    if (_currentNode == null) {
      return Text("Null");
    } else if (_currentNode!.data is FilterModel) {
      return _FilterModelDebugView2(
        filterModel: _currentNode!.data,
      );
    } else if (_currentNode!.data is Criterion) {
      return _FilterCriterionView(
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
    FilterCriteriaStructure filterCriteriaStructure =
        widget.filterModel._filterCriteriaStructure;
    //
    return _CustomAppContainer(
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

          if (data is FilterModel) {
            title = getClassName(data);
            prefixIconData = _filterModelIconData;
          } else if (data is SimpleCriterion) {
            title = data.criterionName;
            prefixIconData = _simplePropOrCriterionIconData;
            //
            isMultiOpt = false;
            isMultiSelection = false;
          } else if (data is MultiOptCriterion) {
            title = data.criterionName;
            prefixIconData = _optPropOrCriterionIconData;
            //
            isMultiOpt = true;
            isMultiSelection = !data.singleSelection;
          } else {
            prefixIconData = _uknownIconData;
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
                      _multiSelectionIconData,
                      size: 16,
                      color: Colors.red,
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  _currentNode = node;
                  if (node.data is Criterion) {
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

  TreeNode _getRootWithChildren() {
    TreeNode filterModelNode = TreeNode(
      key: "FilterModel-${getClassName(widget.filterModel)}",
      data: widget.filterModel,
      parent: null,
    );
    rootTreeNode = TreeNode.root()..add(filterModelNode);
    //
    FilterCriteriaStructure structure =
        widget.filterModel._filterCriteriaStructure;

    List<MultiOptCriterion> rootMultiOptCriterion = structure._rootOptCriteria;
    for (MultiOptCriterion multiOptCriterion in rootMultiOptCriterion) {
      _addMultiOptCriterionCascade(filterModelNode, multiOptCriterion);
    }
    List<SimpleCriterion> simpleCriteria = structure._simpleCriteria;
    for (SimpleCriterion simpleCriterion in simpleCriteria) {
      _addSimpleCriterion(filterModelNode, simpleCriterion);
    }

    return rootTreeNode;
  }

  void _addMultiOptCriterionCascade(
      TreeNode currentNode, MultiOptCriterion multiOptCriterion) {
    TreeNode childNode = TreeNode(
      key: "MultiOptCriterion-${multiOptCriterion.criterionName}",
      data: multiOptCriterion,
    );
    // if (multiOptCriterion == widget.selectedCriterion) {
    //   _currentNode = childNode;
    // }
    currentNode.add(childNode);
    for (MultiOptCriterion childMultiOptCriterion
        in multiOptCriterion.children) {
      _addMultiOptCriterionCascade(childNode, childMultiOptCriterion);
    }
  }

  void _addSimpleCriterion(
      TreeNode currentNode, SimpleCriterion simpleCriterion) {
    TreeNode childNode = TreeNode(
      key: "SimpleCriterion-${simpleCriterion.criterionName}",
      data: simpleCriterion,
    );
    // if (simpleCriterion == widget.selectedCriterion) {
    //   _currentNode = childNode;
    // }
    currentNode.add(childNode);
  }

  void _onPressCriterion(Criterion criterion) {
    print("Criterion: $criterion");
  }
}
